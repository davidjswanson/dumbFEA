project (Console)

include(${CMAKE_SOURCE_DIR}/cmake/project.cmake)

# --------------------- Source -----------------------

set (SOURCEFILES
  src/main.cpp
)

set (HEADERFILES
)

# --------------------- Executable -----------------------

addStandardExecutable()

