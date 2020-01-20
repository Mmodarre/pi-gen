echo "START NEW BUILD" >>build.logs
sudo CLEAN=1 ./build.sh 2>&1 >>build.logs
