#######################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#######################################################################

function(RPI_project)

## #############################################################################
## Prepare the project
## #############################################################################

set(ep_name RPI)
set(EP_NAME RPI)

EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS OFF
  )

EP_SetDirectories(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
  ep_build_dirs
  )


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${EP_NAME}_SOURCE_DIR)
  set(location GIT_REPOSITORY "git@github.com:Inria-Asclepios/RPI.git")
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

# set compilation flags
set(${ep_name}_c_flags "${ep_common_c_flags} ${${ep_name}_c_flags}")
set(${ep_name}_cxx_flags "${ep_common_cxx_flags} ${${ep_name}_cxx_flags}")
  
if (UNIX)
  set(${ep_name}_c_flags "${${ep_name}_c_flags} -Wall")
  set(${ep_name}_cxx_flags "${${ep_name}_cxx_flags} -Wall")
endif()

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep_name}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep_name}_cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep_name}}  
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DRPI_BUILD_EXAMPLES:BOOL=OFF
  )


## #############################################################################
## Resolve dependencies with other external-project
## #############################################################################

list(APPEND dependencies 
  ITK
  )
  
foreach(dependence ${dependencies})
 if (USE_SYSTEM_${dependence})
  list(REMOVE_ITEM dependencies ${dependence})
 endif()
endforeach()


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_build_dirs}
  ${location}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  INSTALL_COMMAND ""
  DEPENDS ${dependencies}
  ) 
  
## #############################################################################
## Finalize
## #############################################################################
  
EP_ForceBuild(${ep_name})

ExternalProject_Get_Property(${ep_name} binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
