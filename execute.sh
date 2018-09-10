#!/bin/bash

ROOT=$(pwd)
BUILD_DIR=$ROOT/tmp-build
PREFIX=$ROOT/src/
RESULT_DIR=$ROOT/results

TESTCASE=$(basename -s .java $1)

JAVAC=/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home/bin/javac

JAVA=/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home/bin/java
ZULU=/Library/Java/JavaVirtualMachines/zulu-10.jdk/bin/java

RUNS=$2

if [ "$#" -eq 1 ]; then
    RUNS=1
fi

echo "Testing $1"
echo "Compiling  ----------------------"

mkdir -p $BUILD_DIR
mkdir -p $RESULT_DIR
cd $BUILD_DIR

pwd

echo "# javac"
cat $ROOT/lib/VirtualMachine.java $PREFIX$1 > $BUILD_DIR/$1
$JAVAC $1

echo "# cij compiler"
$JAVA -jar $ROOT/bin/compiler.jar -d $PREFIX$1 $1.cij

# command label
function runner() {
    (time -p eval $1) 2>&1 >$TESTCASE.$2.timing.$i.txt | sed -n -e 's/[a-zA-Z ]\{0,100\}\([0-9]\{1,10\}\.[0-9]\{1,10\}\)/\1/p' | paste -sd ';' - > $TESTCASE.$2.overall.$i.txt

    cat $TESTCASE.$2.timing.$i.txt $TESTCASE.$2.overall.$i.txt | paste -sd ';' - > $TESTCASE.$2.$i.txt

    cat $TESTCASE.$2.$i.txt
}


echo "Executing ----------------------" && \
for i in `seq 1 $RUNS` ; do
    echo "# java"

    runner "$JAVA $TESTCASE" "java"

    echo "# java int"
    runner "$JAVA -Xint $TESTCASE" "javaint"

    echo "# java jit"
    # maybe add -XX:+UnlockDiagnosticVMOptions -XX:CompilerDirectivesFile=$ROOT/java-jit-options.txt ?
    runner "$JAVA -XX:+AggressiveOpts -XX:CompileThreshold=1 $TESTCASE" "javajit"

    echo "# zulu"
    runner "$ZULU $TESTCASE" "zulu"

    echo "# cij jit"
    runner "$ROOT/bin/vm jit $1.cij" "cijjit"

    echo "# cij int"
    runner "$ROOT/bin/vm int $1.cij" "cijint"

    echo "--------"

    # TESTCASE ; round ; java:real ; java:user ; java:sys ; jit:{real,user,sys} ; int:{real,user,sys}

    NUMBERS=$(cat $TESTCASE.java.$i.txt $TESTCASE.javaint.$i.txt $TESTCASE.javajit.$i.txt $TESTCASE.zulu.$i.txt $TESTCASE.cijjit.$i.txt $TESTCASE.cijint.$i.txt | paste -sd ';' -)

    echo "$TESTCASE;$i;$NUMBERS" >> $RESULT_DIR/$TESTCASE.csv

done

cd $ROOT
rm -rf $BUILD_DIR
