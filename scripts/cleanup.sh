#!/bin/bash -xe

cleanup ()
{
  echo "cleaning up"
  set +e
  set +x
  CU_AGENT_RUNNING=`docker ps -q -f name=ecs-agent`
  CU_ALL_RUNNING=`docker ps -q`
  cu_all_running_arr=($CU_ALL_RUNNING)
  cu_filtered_arr=(${cu_all_running_arr[@]/$CU_AGENT_RUNNING})
  CU_RUNNING=${cu_filtered_arr[@]}
  echo $CU_RUNNING
  if [ "$CU_RUNNING" -a "$CU_RUNNING" != " " ]; then
    docker kill $CU_RUNNING
  fi
  CU_STOPPED=`docker ps -a -q`
  if [ "$CU_STOPPED" -a "$CU_STOPPED" != " " ]; then
    docker rm -f $CU_STOPPED
  fi
  CU_AGENT_IMAGE=`docker images | grep -Po "^amazon\/amazon-ecs-agent\s+latest\s+[0-9a-f]{12}" | grep -Po "[0-9a-f]{12}$"`
  CU_ALL_IMAGES=`docker images -q`
  cu_all_images_arr=($CU_ALL_IMAGES)
  cu_filtered_img_arr=(${cu_all_images_arr[@]/$CU_AGENT_IMAGE})
  CU_IMAGES=${cu_filtered_img_arr[@]}
  if [ "$CU_IMAGES" -a "$CU_IMAGES" != " " ]; then
    docker rmi -f $CU_IMAGES
  fi
  set -e
  set -x
}

cleanup
