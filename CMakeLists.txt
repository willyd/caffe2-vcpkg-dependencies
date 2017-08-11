cmake_minimum_required(VERSION 3.8)

project(test_vcpkg)

find_package(gflags REQUIRED)
find_package(glog REQUIRED)
find_package(lmdb REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Eigen3 REQUIRED)