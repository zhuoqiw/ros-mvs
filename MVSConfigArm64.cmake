if(NOT TARGET MVS::MVS)
  add_library(MVS::MVS SHARED IMPORTED)
  set_target_properties(MVS::MVS PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/aarch64/libMvCameraControl.so.3.1.3.0"
  )
endif()
