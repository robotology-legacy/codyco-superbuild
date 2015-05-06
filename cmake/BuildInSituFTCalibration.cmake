include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(Eigen3 QUIET)

ycm_ep_helper(InSituFTCalibration TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/insitu-ft-calibration.git
              TAG master
              COMPONENT libraries
              DEPENDS Eigen3)
