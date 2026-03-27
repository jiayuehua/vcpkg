vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO freetds/freetds
    REF "v${VERSION}"
    HEAD_REF master
    SHA512 09f526828ab5c57c9ccab62a43242d0e0d7b81e42194d27ba3f6c89d67b9b6aad375f852a4a8e4aac7b437c507cd3ca6f04933da7bf4cb2d8c2166dddf6fa0e2
    PATCHES
        disable-tests.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        openssl WITH_OPENSSL
        tools WITH_TOOLS
)

vcpkg_find_acquire_program(PERL)
get_filename_component(PERL_PATH ${PERL} DIRECTORY)
vcpkg_add_to_path("${PERL_PATH}")

vcpkg_add_to_path(PREPEND "${CURRENT_HOST_INSTALLED_DIR}/tools/gperf")

set(_WCHAR_SUPPORT ON)
if(NOT VCPKG_TARGET_IS_WINDOWS)
    set(_WCHAR_SUPPORT OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        ${FEATURE_OPTIONS}
        -DENABLE_ODBC_WIDE=${_WCHAR_SUPPORT}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES bsqldb bsqlodbc datacopy defncopy freebcp tdspool tsql AUTO_CLEAN)
    if(EXISTS "${CURRENT_PACKAGES_DIR}/etc")
        file(INSTALL "${CURRENT_PACKAGES_DIR}/etc" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}/etc")
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/etc" "${CURRENT_PACKAGES_DIR}/debug/etc")

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(INSTALL "${SOURCE_PATH}/COPYING.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
