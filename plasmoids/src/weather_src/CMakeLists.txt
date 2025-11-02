cmake_minimum_required(VERSION 3.16)

project(io.gitgud.catpswin56.gadgets.weather)

set(QT_MIN_VERSION "6.7.0")
set(KF6_MIN_VERSION "6.0.0")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMQtDeclareLoggingCategory)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMFindQmlModule)
include(ECMQmlModule)
include(FeatureSummary)
include(GenerateExportHeader)

find_package(Plasma)
find_package(PlasmaQuick)

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Quick
    Core
    Qml
    Gui
    Network
    DBus
)

find_package(KF6 REQUIRED COMPONENTS
    I18n
    UnitConversion
    KIO
    Holidays
)

add_subdirectory(weather)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
