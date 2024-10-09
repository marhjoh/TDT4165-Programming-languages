name := "BankSystem"

version := "1.0"

scalaVersion := "2.12.19"

libraryDependencies += "org.scalatest" %% "scalatest" % "3.0.0" % "test"

resolvers += "Central" at "https://central.maven.org/maven2/"

scalacOptions := Seq("-unchecked", "-deprecation", "-feature", "-language:postfixOps")