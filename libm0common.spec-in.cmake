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

%description
the libm0common provides a few functions that wraps some calls
from the MOTR API. It is used by KVSAL/MOTR and EXTSTORE/MOTR inside
the IO-SEA namespace tools.

%package devel
Summary: Development file for the library libextstore
Group: Development/Libraries
Requires: %{name} = %{version}-%{release} pkgconfig
Provides: %{name}-devel = %{version}-%{release}

%description devel
the libm0common provides a few functions that wraps some calls
from the MOTR API. It is used by KVSAL/MOTR and EXTSTORE/MOTR inside
the IO-SEA namespace tools.


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
