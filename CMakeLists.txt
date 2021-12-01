cmake_minimum_required(VERSION 2.6.4)
cmake_policy(SET CMP0017 NEW)

PROJECT(libm0common C)
set(LIBM0COMMON_MAJOR_VERSION 1)
set(LIBM0COMMON_MINOR_VERSION 3)
set(LIBM0COMMON_PATCH_LEVEL 0)
set(LIBM0COMMON_EXTRA_VERSION "")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${CMAKE_SOURCE_DIR}/include -fPIC -g")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror")

set(LIBM0COMMON_BASE_VERSION ${LIBM0COMMON_MAJOR_VERSION}.${LIBM0COMMON_MINOR_VERSION}.${LIBM0COMMON_PATCH_LEVEL})

message( STATUS "cmake version ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}" )
message( STATUS "libm0common version ${LIBM0COMMON_BASE_VERSION}")

# Final tuning

include(CheckIncludeFiles)
include(CheckLibraryExists)

## Check for MOTR
find_library(HAVE_MOTR motr)
check_library_exists(
        motr
        m0_init
        ""
        HAVE_MOTR
	)
check_include_files("motr/config.h" HAVE_MOTR_H)

if((NOT HAVE_MOTR) OR (NOT HAVE_MOTR_H))
      message(FATAL_ERROR "Cannot find motr")
endif((NOT HAVE_MOTR) OR (NOT HAVE_MOTR_H))

### Check for rados ###
check_library_exists(
	rados
	rados_connect
	""
	HAVE_LIBRADOS
	)
check_include_files("rados/librados.h" HAVE_RADOS_H)

if((NOT HAVE_LIBRADOS) OR (NOT HAVE_RADOS_H))
      message(STATUS "Cannot find librados")
endif((NOT HAVE_LIBRADOS) OR (NOT HAVE_RADOS_H))


add_subdirectory(motr)


# CPack / rpmbuild specific stuff
set(CPACK_PACKAGE_FILE_NAME "libm0common-Source" )
set(CPACK_PACKAGE_VENDOR "LIBM0COMMON")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "LIBM0COMMON - an object store abstraction for KVSNS")
SET(CPACK_PACKAGE_VERSION_MAJOR ${LIBM0COMMON_MAJOR_VERSION})
SET(CPACK_PACKAGE_VERSION_MINOR ${LIBM0COMMON_MINOR_VERSION})
SET(CPACK_PACKAGE_VERSION_PATCH ${LIBM0COMMON_PATCH_LEVEL})

# Tell CPack the kind of packages to be generated
set(CPACK_GENERATOR "TGZ")
set(CPACK_SOURCE_GENERATOR "TGZ")

set(CPACK_SOURCE_IGNORE_FILES
  "/.git/;/.gitignore/;/build/;/.bzr/;~$;${CPACK_SOURCE_IGNORE_FILES}")

include(CPack)

set(PKG_NAME "${CPACK_PACKAGE_NAME}.tar.gz")
if(NOT WITHIN_IOSEA_NAMESPACE_REPO)
  add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)
endif(NOT WITHIN_IOSEA_NAMESPACE_REPO)

# Create the .pc file
configure_file(
  "${PROJECT_SOURCE_DIR}/libm0common.pc-in.cmake"
  "${PROJECT_SOURCE_DIR}/libm0common.pc"
)

# Now create a useable specfile
configure_file(
  "${PROJECT_SOURCE_DIR}/libm0common.spec-in.cmake"
  "${PROJECT_SOURCE_DIR}/libm0common.spec"
)

configure_file(
  "${PROJECT_SOURCE_DIR}/libm0common.pc-in.cmake"
  "${PROJECT_SOURCE_DIR}/libm0common.pc"
)

set(RPMDEST "--define '_srcrpmdir ${CMAKE_CURRENT_BINARY_DIR}'")

if(NOT WITHIN_IOSEA_NAMESPACE_REPO)
  add_custom_target( rpms DEPENDS dist)
  add_custom_command(TARGET rpms
                    COMMAND sh -c "rpmbuild ${RPMDEST} -ta ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.gz"
                    VERBATIM
                    DEPENDS dist)

  add_custom_target( rpm DEPENDS dist)
  add_custom_command(TARGET rpm
                    COMMAND sh -c "rpmbuild ${RPMDEST} -tb ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.gz"
                    VERBATIM
                    DEPENDS dist)

  add_custom_target( srpm DEPENDS dist)
  add_custom_command(TARGET srpm
                    COMMAND sh -c "rpmbuild ${RPMDEST} -ts ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.gz"
                    VERBATIM
                    DEPENDS dist)
endif(NOT WITHIN_IOSEA_NAMESPACE_REPO)

# INSTALL
install(FILES ${PROJECT_SOURCE_DIR}/libm0common.pc DESTINATION lib)
#install(DIRECTORY ${PROJECT_SOURCE_DIR}/iosea DESTINATION include)
install(FILES ${PROJECT_SOURCE_DIR}/motr/m0common.h DESTINATION include/iosea)
