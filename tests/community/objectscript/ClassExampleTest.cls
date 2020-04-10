Class community.objectscript.ClassExampleTest Extends %UnitTest.TestCase
{

Method TestGetTheUniverseSecret()
{
	Do $$$AssertEquals("42", ##class(community.objectscript.ClassExample).GetTheUniverseSecret(), "The universe secret is 42")
}

}
