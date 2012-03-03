/*******************************************************************************
*                                                                              *
*  Folder Gallery main source file.                                            *
*                                                                              *
*  Copyright (C) 2011 Kirill Chuvilin.                                         *
*  All rights reserved.                                                        *
*  Contact: Kirill Chuvilin (kirill.chuvilin@gmail.com, kirik-ch.ru)           *
*                                                                              *
*  This file is part of the Folder Gallery project.                            *
*                                                                              *
*  $QT_BEGIN_LICENSE:GPL$                                                      *
*  You may use this file under the terms of the GNU General Public License     *
*  as published by the Free Software Foundation; version 3 of the License.     *
*                                                                              *
*  This file is distributed in the hope that it will be useful,                *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of              *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                *
*  GNU General Public License for more details.                                *
*                                                                              *
*  You should have received a copy of the GNU General Public License           *
*  along with this package; if not, write to the Free Software                 *
*  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.   *
*  $QT_END_LICENSE$                                                            *
*                                                                              *
*******************************************************************************/

#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

#include <QtDeclarative>
#include "mediafiles/MediaFile.h"
#include "mediafiles/MediaDir.h"
#include "mediafiles/MediaRoots.h"
#include "mediafiles/MediaPreviewImageProvider.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QmlApplicationViewer viewer;

    app.setApplicationName(app.trUtf8("Folder Gallery"));

    qmlRegisterType<MediaFile>("MediaFile", 1, 0, "MediaFile");
    qmlRegisterType<MediaDir>("MediaDir", 1, 0, "MediaDir");
    qmlRegisterType<MediaThumbnailDb>("MediaThumbnailDb", 1, 0, "MediaThumbnailDb");
    qmlRegisterType<MediaRoots>("MediaRoots", 1, 0, "MediaRoots");

    viewer.engine()->addImageProvider(QLatin1String("preview"), new MediaPreviewImageProvider);

#if defined(Q_WS_MAEMO_5)
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/Main_fremantle.qml"));
    viewer.showFullScreen();
#elif defined(Q_WS_HARMATTAN)
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/Main_harmattan.qml"));
    viewer.showFullScreen();
#elif defined(Q_OS_SYMBIAN)
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/Main_symbian.qml"));
    viewer.showFullScreen();
#else
//    (defined(Q_WS_WIN) || defined(Q_WS_X11))
    viewer.setMainQmlFile(QLatin1String("qml/Main_desktop.qml"));
    viewer.show();
#endif
//    viewer.showExpanded();
    return app.exec();
}
