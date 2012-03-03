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

#ifndef _MediaRoots_h_
#define _MediaRoots_h_

#include <QObject>
#include <QList>
#include "MediaDir.h"
#include "MediaThumbnails.h"
#include "DeclarativeList.h"

class MediaRoots : public QObject {
    Q_OBJECT

    Q_PROPERTY(int count READ getCount CONSTANT) // number of directories in list
    Q_PROPERTY(QDeclarativeListProperty<MediaDir> list READ getList CONSTANT) // list of directories where images are
    Q_PROPERTY(QString thumbnailDirPath READ getThumbnailDirPath WRITE setThumbnailDirPath NOTIFY thumbnailDirPathChanged) // absolute path to dir with thumbnail files
    Q_PROPERTY(QString appDataDirPath READ getAppDataDirPath CONSTANT) // documents directory

public:
    /*
      Constructor.
    */
    explicit MediaRoots(QObject *parent = 0);

    /*
      Returns number of directories.
    */
    int getCount() const {return this->m_list.count();}

    /*
      Returns directory list.
    */
    QDeclarativeListProperty<MediaDir> getList() {return DeclarativeList<MediaDir>::generateProperty(this, &(this->m_list), false, true);}

    /*
      Returns absolute path to dir with thumbnail files.
    */
    QString getThumbnailDirPath() const {return this->thumbnalBase.getDirPath();}

    /*
      Returns absolute path to documents directory.
    */
    QString getAppDataDirPath() const;

public slots:
    /*
      Sets dir for thumbnail files.
      dirPath - absolute path to dir
    */
    void setThumbnailDirPath(const QString dirPath);

signals:
    /*
      Emits when thumbnailDirPath ptoperty changes.
    */
    void thumbnailDirPathChanged();

private:
    QList<MediaDir*> m_list; // directory list
    MediaThumbnailsBase thumbnalBase; // thumbnail generator
};

#endif // _MediaRoots_h_
