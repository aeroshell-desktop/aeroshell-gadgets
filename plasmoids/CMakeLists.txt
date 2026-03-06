add_subdirectory(src)

set(plasmoids
    io.gitgud.catpswin56.gadgets.clock
    io.gitgud.catpswin56.gadgets.cpu
    io.gitgud.catpswin56.gadgets.notes
    io.gitgud.catpswin56.gadgets.rssfeeds
)

foreach(plasmoid IN LISTS plasmoids)
    plasma_install_package(${plasmoid} ${plasmoid})
endforeach()

