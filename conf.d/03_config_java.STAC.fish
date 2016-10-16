set -gx JDK_HOME        /opt/jdk/jdk1.8.0_102
set -gx JAVA_HOME       $JDK_HOME

set -gx DRIP_SHUTDOWN   30 #minutes

conf.padd $JDK_HOME/jre/bin $JAVA_HOME/bin

set -gx SCALA_HOME      /opt/jdk/scala-2.11.7

conf.padd $SCALA_HOME/bin /opt/jdk/sbt/bin

set -gx M2_HOME     /opt/jdk/apache-maven-3.3.9
set -gx MAVEN_HOME  $M2_HOME
set -gx MVN_HOME    $M2_HOME

conf.padd $M2_HOME/bin

set -gx ANT_HOME    /opt/jdk/apache-ant-1.9.6

conf.padd $ANT_HOME/bin

set -gx GRADLE_HOME /opt/jdk/gradle-3.3-snapshot-1

conf.padd $GRADLE_HOME/bin

conf.padd $HOME/.conscript/bin
