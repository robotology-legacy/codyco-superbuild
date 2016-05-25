# icub_gazebo
include(YCMEPHelper)

ycm_ep_helper(icub-gazebo
              TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/icub-gazebo.git
              TAG master
              COMPONENT main
              CONFIGURE_COMMAND ""
              BUILD_COMMAND ""
              INSTALL_COMMAND "")
