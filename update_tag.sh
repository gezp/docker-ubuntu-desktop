#!/bin/bash

ubuntu_tags=(18.04 20.04)
ubuntu18_cuda_tags=(10.1 10.2 11.0 11.1 11.2.0 11.3.0 11.4.0)
ubuntu20_cuda_tags=(11.0 11.1 11.2.0 11.3.0 11.4.0)

for value in ${ubuntu_tags[@]}
do
    git tag $value -f
    git push origin $value -f
done

for value in ${ubuntu18_cuda_tags[@]}
do
    git tag 18.04-cu$value -f
    git push origin 18.04-cu$value -f
done

for value in ${ubuntu20_cuda_tags[@]}
do
    git tag 20.04-cu$value -f
    git push origin 20.04-cu$value -f
done

exit 0