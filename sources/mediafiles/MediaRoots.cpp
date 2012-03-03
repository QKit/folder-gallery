/*******************************************************************************
*                                                                              *
*  Root directories of media files implementation.                             *
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

#include "MediaRoots.h"


MediaRoots::MediaRoots(QObject *parent) :
    QObject(parent) {
    this->thumbnailsDb.setDirPath(this->getAppDataDirPath() + "/.thumbnails");
    this->thumbnailsDb.refresh();
    QStringList imageRoots;
#if defined(Q_WS_MAEMO_5)
    imageRoots << QDir::homePath();
    imageRoots << QDir::homePath() + "/MyDocs";
    imageRoots << QDir::homePath() + "/MyDocs/.images";
    imageRoots << QDir::homePath() + "/MyDocs/DCIM";
    imageRoots << "/media/mmc1";
#elif defined(Q_WS_HARMATTAN)
    imageRoots << QDir::homePath();
    imageRoots << QDir::homePath() + "/MyDocs";
    imageRoots << QDir::homePath() + "/MyDocs/Pictures";
    imageRoots << QDir::homePath() + "/MyDocs/DCIM";
#elif defined(Q_OS_SYMBIAN)
    imageRoots << QDir::homePath();
    imageRoots << "C:/data";
    imageRoots << "C:/data/Images";
    imageRoots << "E:";
    imageRoots << "E:/Images";
#elif defined(Q_WS_WIN)
//    imageRoots << QDir::homePath();
    imageRoots << QDir::homePath() + "/Pictures";
#else
    imageRoots << QDir::homePath();
#endif
    foreach (QString imageRoot, imageRoots) {
        if (QDir(imageRoot).isReadable()) {
            MediaDir* newMediaDir = new MediaDir(imageRoot);
            QObject::connect(newMediaDir, SIGNAL(generateThumbnail(QUrl)), &(this->thumbnailsDb), SLOT(generateThumbnail(QUrl))); // for thumbnail generation
            this->m_list.append(newMediaDir);
        }
    }
}


QString MediaRoots::getAppDataDirPath() const {
#if defined(Q_WS_MAEMO_5)
    return QDir::homePath() + "/MyDocs";
#elif defined(Q_WS_HARMATTAN)
    return QDir::homePath() + "/MyDocs";
#elif defined(Q_OS_SYMBIAN)
    if (QDir("E:").exists()) // if there is flash card
        return "E:/data";
    else // if no flash card
        return "C:/data";
#else
    return QDir::homePath();
#endif
}


void MediaRoots::setThumbnailDirPath(const QString dirPath) {
    this->thumbnailsDb.setDirPath(dirPath);
    emit thumbnailDirPathChanged();
}
