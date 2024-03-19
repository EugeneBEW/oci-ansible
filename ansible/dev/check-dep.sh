#/bin/bash

for i in *.deb ; do echo $i ; dpkg --info $i | grep 'Depends:' ; done | \
	sed -e 's/,/\n/g' -e 's/Depends://g' | sort | \
	#sed -e 's/(.*)//' | \
	# grep -v libc6 | \
	uniq | \
  sed -e  's/^\s/>/g'  

