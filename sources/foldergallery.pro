# Add more folders to ship with the application, here
folder_qml.source = qml
folder_qml.target = .
DEPLOYMENTFOLDERS = folder_qml

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

VERSION = 1.5.1

symbian {
    TARGET.UID3 = 0x2004a654
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment
    vendorinfo += "%{\"Kirill Chuvilin\"}" ":\"Kirill Chuvilin\""
    DEPLOYMENT.display_name += Folder Gallery
}

maemo5 {
    target.path = /opt/foldergallery/bin
    INSTALLS += target
}

contains(MEEGO_EDITION,harmattan) {
    DEFINES += Q_WS_HARMATTAN # definition for harmattan
    target.path = /opt/foldergallery/bin
    INSTALLS += target
    # enable booster
    QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
    QMAKE_LFLAGS += -pie -rdynamic
}

# enable booster
CONFIG += qdeclarative-boostable

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    mediafiles/MediaDir.h \
    mediafiles/MediaFile.h \
    mediafiles/MediaRoots.h \
    mediafiles/MediaThumbnails.h \
    DeclarativeList.h

SOURCES += main.cpp \
    mediafiles/MediaDir.cpp \
    mediafiles/MediaFile.cpp \
    mediafiles/MediaRoots.cpp \
    mediafiles/MediaThumbnails.cpp

OTHER_FILES += \
    foldergallery.svg \
    foldergallery.desktop \
    foldergallery64.png \
    foldergallery_harmattan.desktop \
    foldergallery80.png \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog

