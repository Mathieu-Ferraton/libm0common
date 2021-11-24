%define sourcename @CPACK_SOURCE_PACKAGE_FILE_NAME@
%global dev_version %{lua: extraver = string.gsub('@LIBM0COMMON_EXTRA_VERSION@', '%-', '.'); print(extraver) }

Name: libm0common 
Version: @LIBM0COMMON_BASE_VERSION@
Release: 0%{dev_version}%{?dist}
Summary: Library to access to a namespace inside a KVS
License: LGPLv3 
Group: Development/Libraries
Url: http://github.com/phdeniel/libm0common
Source: %{sourcename}.tar.gz
BuildRequires: cmake libini_config-devel
BuildRequires: gcc
Provides: %{name} = %{version}-%{release}
Requires: %{name} = %{version}-%{release} cortx-motr
Provides: %{name} = %{version}-%{release}

# Conditionally enable KVS and object stores
#
# 1. rpmbuild accepts these options (gpfs as example):
#    --without redis

%define on_off_switch() %%{?with_%1:ON}%%{!?with_%1:OFF}

# A few explanation about %bcond_with and %bcond_without
# /!\ be careful: this syntax can be quite messy
# %bcond_with means you add a "--with" option, default = without this feature
# %bcond_without adds a"--without" so the feature is enabled by default

%description
The libm0common is a library that allows of a POSIX namespace built on top of
a Key-Value Store.

%package devel
Summary: Development file for the library libextstore
Group: Development/Libraries
Requires: %{name} = %{version}-%{release} pkgconfig
Provides: %{name}-devel = %{version}-%{release}

%description devel
The devel package for libm0common


%prep
%setup -q -n %{sourcename}

%build
cmake . 

make %{?_smp_mflags} || make %{?_smp_mflags} || make

%install

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libdir}
mkdir -p %{buildroot}%{_libdir}/pkgconfig
mkdir -p %{buildroot}%{_includedir}/iosea
install -m 644 motr/libm0common.so %{buildroot}%{_libdir}
install -m 644 libm0common.pc  %{buildroot}%{_libdir}/pkgconfig
install -m 644 motr/m0common.h  %{buildroot}%{_includedir}/iosea


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_libdir}/libm0common.so*

%files devel
%defattr(-,root,root)
%{_libdir}/pkgconfig/libm0common.pc
%{_includedir}/iosea/m0common.h




%changelog
* Wed Nov  3 2021 Philippe DENIEL <philippe.deniel@cea.fr> 1.3.0
- Better layering between kvsns, kvsal aand extstore. 
