#!/bin/sh

ROOT=$(pwd)

make_me_tagged()
{
	ctags --totals=yes -f .tags -B --languages=c,c++ --append=yes \
	--kinds-c=+defghstu --kinds-c++=+cdefghstun --links=no \
	--recurse=yes \
	--tag-relative=yes \
	$@

# ctags --totals=yes -f .tags -B --languages=c,c++ --append=yes \
# 	--c-kinds=+cdefgstu-lmpvx --c++-kinds=+cdefgstu-lmpvx --links=no \
# 	--recurse=yes \
# 	--tag-relative=yes \
# 	$@
}

openyuma_tag()
{
	cd ./OpenYuma-master
	
	make_me_tagged \
    ./netconf ;
	
	cd $ROOT
}

main()
{
	openyuma_tag $@
}

main $@
