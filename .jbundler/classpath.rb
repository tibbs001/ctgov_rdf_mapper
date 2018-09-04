require 'jar_dependencies'
JBUNDLER_LOCAL_REPO = Jars.home
JBUNDLER_JRUBY_CLASSPATH = []
JBUNDLER_JRUBY_CLASSPATH.freeze
JBUNDLER_TEST_CLASSPATH = []
JBUNDLER_TEST_CLASSPATH.freeze
JBUNDLER_CLASSPATH = []
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bcprov-jdk15on/1.59/bcprov-jdk15on-1.59.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/yaml/snakeyaml/1.18/snakeyaml-1.18.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/jline/jline/2.11/jline-2.11.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bctls-jdk15on/1.59/bctls-jdk15on-1.59.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bcpkix-jdk15on/1.59/bcpkix-jdk15on-1.59.jar')
JBUNDLER_CLASSPATH.freeze
