cmake_minimum_required(VERSION 3.16)
project(win-gadgets)

set(PROJECT_VERSION 6.6.2)
set(PROJECT_VERSION_MAJOR 6)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_MAJOR_VERSION 6)
find_package(ECM ${QT_MAJOR_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs NO_POLICY_SCOPE)
include(KDECMakeSettings NO_POLICY_SCOPE)
include(ECMQtDeclareLoggingCategory)

include(KDECompilerSettings NO_POLICY_SCOPE)
# we don't need ts
remove_definitions(-DQT_NO_CAST_TO_ASCII -DQT_NO_CAST_FROM_ASCII -DQT_USE_QSTRINGBUILDER)

include(ECMFindQmlModule)
include(ECMQmlModule)
include(FeatureSummary)
include(GenerateExportHeader)

find_package(Plasma)
find_package(PlasmaQuick)

find_package(Qt${QT_MAJOR_VERSION} CONFIG REQUIRED COMPONENTS
    Quick
    Core
    Qml
    Gui
    Network
    DBus
)

find_package(KF${QT_MAJOR_VERSION} REQUIRED COMPONENTS
    I18n
    UnitConversion
    KIO
    Holidays
)

add_subdirectory(plasmoids)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
