## Classloader Hierarchy

- Bootstrap classloader: loads the $JAVA_HOME/jre/lib modules and jdk internal classes
- Extension classloader: loads the extensions of the core Java classes
- System (application) classloader: loads all classes mentioned in the classpath env variable, together with application classes

Context classloader per thread
