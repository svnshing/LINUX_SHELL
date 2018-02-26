#!/bin/sh
# This script use to do the 530-system archivism process
# Author liwj
# modify time:2018-02-11

scannerDir=$(grep "scannerDir" archivism-profit.xml|awk -F '>' '{print $2}'|awk -F '<' '{print $1}');
echo "scanner path is "$scannerDir;
targetDir=$(grep "targetDir" archivism-profit.xml|awk -F '>' '{print $2}'|awk -F '<' '{print $1}');
echo "outputZip path is "$targetDir;
fileSubfix=".zip";
sourceBackDir="./sourceBackedDir"; 
if [ ! -d $scannerDir ];then
	echo "mkdir $scannerDir";
	mkdir -p "$scannerDir";
fi

if [ ! -d $targetDir ];then
	echo "mkdir $targetDir";
	mkdir -p "$targetDir";
fi

if [ ! -d $sourceBackDir  ];then
	echo "mkdir $sourceBackDir";
	mkdir -p "$sourceBackDir";
fi

tarFiles(){
	echo "pack file is ${1}";
    echo "zip to ${targetDir}/$1$3 from ${scannerDir}/$1";
	tar -zcf ${targetDir}/$1$3 ${scannerDir}/$1;
    rm -f $4;
	echo "move $5 to $6";
    mv $5 $6;
}

moveFiles(){	
	echo "move file is ${1}"
	rm -f $2;
	mv $1 $3;
}

targetTxtList=$(find "$scannerDir" -name "*_archivism.finish");
if [ -n "$targetTxtList" ];then
	echo "targetFiles are "$targetTxtList;
else 
	echo "no targetFile exists";
fi
startTime=`date  +"%s"`;
for toDeleteFileName in $targetTxtList
do
	targetFileNameWithPath=${toDeleteFileName%/*};
	caseCodeFileName=${targetFileNameWithPath##*/};
	tarFiles $caseCodeFileName $targetDir $fileSubfix $toDeleteFileName  $targetFileNameWithPath $sourceBackDir;
#	moveFiles $targetFileNameWithPath $toDeleteFileName $targetDir;
	echo "$caseCodeFileName true">>"$scannerDir/archivism.log";
	sleep 1;
done

endTime=`date +"%s"`;

diff=$[endTime-startTime];

echo "time:${diff}s";

echo "operate files is successful!!!!";
