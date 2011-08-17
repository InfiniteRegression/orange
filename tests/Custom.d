/**
 * Copyright: Copyright (c) 2011 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Aug 17, 2011
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module tests.Custom;

import orange.core._;
import orange.serialization.Serializer;
import orange.serialization.archives.XMLArchive;
import orange.test.UnitTester;
import tests.Util;

Serializer serializer;
XMLArchive!(char) archive;

class Base
{
	int c;
}

class Foo : Base
{
	int a;
	int b;
	
	void toData (Serializer serializer, Serializer.Data key)
	{
		serializer.serialize(a, "x");
		println(cast(string) key);
	}

	void fromData (Serializer serializer, Serializer.Data key)
	{
		a = serializer.deserialize!(int)("x");
		println(cast(string) key);
	}
}

Foo foo;

unittest
{
	archive = new XMLArchive!(char);
	serializer = new Serializer(archive);
	
	foo = new Foo;
	foo.a = 3;
	foo.b = 4;
	foo.c = 5;

	describe("serialize object using custom serialization methods") in {
		it("should return a custom serialized object") in {
			serializer.serialize(foo);
			println(archive.data);
			assert(archive.data().containsDefaultXmlContent());
			assert(archive.data().containsXmlTag("object", `runtimeType="tests.Custom.Foo" type="Foo" key="0" id="0"`));
			assert(archive.data().containsXmlTag("int", `key="x" id="1"`));
		};
	};
	
	describe("deserialize object using custom serialization methods") in {
		it("short return a custom deserialized object equal to the original object") in {
			auto f = serializer.deserialize!(Foo)(archive.untypedData);

			assert(foo.a == f.a);
		};
	};
}