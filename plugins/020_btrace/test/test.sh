javac Start.java
java -javaagent:../btrace/build/btrace-agent.jar=script=../btrace/com/sun/btrace/samples/Timers.class,scriptOutputFile=/tmp/out Start
