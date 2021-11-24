project('libm0common',
	 'c',
	 version: '1.3.0',
	 license: 'LGPL3.0-or-later',
	 default_options : ['default_library=shared',
			     'werror=true'])

cc = meson.get_compiler('c')

motr_lib = cc.find_library('libmotr', required: false)
pthread_lib = cc.find_library('pthread', required: true)
ini_config_lib = cc.find_library('libini_config', required: true)

if motr_lib.found()
   uuid_lib = cc.find_library('libuuid', required: true)
   yaml_lib = cc.find_library('libyaml', required: true)
endif

options = cc.get_supported_arguments([
    '-Werror', 
    '-Wall'
])
add_project_arguments(options, language: 'c')

motr_options = cc.get_supported_arguments([
    '-D_REENTRANT',
    '-D_GNU_SOURCE',
    '-DM0_INTERNAL= ',
    '-DM0_EXTERN=extern',
    '-Werror',
    '-Wall',
    '-Wno-attributes',
    '-Wno-unused-but-set-variable',
    '-fno-strict-aliasing',
    '-fno-omit-frame-pointer',
    '-fno-common',
    '-fPIC'])
  add_project_arguments(motr_options, language: 'c')

subdir('motr')


conf_data = configuration_data()
conf_data.set('LIBM0COMMON_BASE_VERSION', meson.project_version())
conf_data.set('LIBM0COMMON_EXTRA_VERSION', '')

distfile = meson.project_name() +  '-' + meson.project_version()
conf_data.set('CPACK_SOURCE_PACKAGE_FILE_NAME', distfile)

# Build the spec file
configure_file(input : 'libm0common.spec-in.meson',
               output : 'libm0common.spec',
               configuration : conf_data)

filespec = meson.source_root() + '/libm0common.spec'
distdir = meson.build_root() + '/meson-dist/' + meson.project_name() +  '-' + meson.project_version()

meson.add_dist_script('/usr/bin/cp', filespec, distdir)
