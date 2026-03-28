vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO png85/json_spirit
    REF "json_spirit-${VERSION}"
    SHA512 94e410e046d0b53fd6e70cefec0e56581fe406dba6f74ce353f5e6ead68d06ff9feab5ff86cb02d2bd8e2e64a20971f1b18c00d7f209d09d0dc0606f2beb9da5
    HEAD_REF master
    PATCHES
        dll-wins.patch
        Fix-link-error-C1128.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_STATIC_LIBS=OFF
        -DJSON_SPIRIT_DEMOS=OFF
        -DJSON_SPIRIT_TESTS=OFF
)

vcpkg_cmake_install()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
vcpkg_copy_pdbs()
