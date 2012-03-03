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
#include "MediaThumbnailDb.h"
#include "DeclarativeList.h"

/*!
 * \brief Media roots class.
 * \author KiRiK aka Kirill Chuvilin (kirik-ch.ru)
 */
class MediaRoots : public QObject {
    Q_OBJECT

    Q_PROPERTY(int count READ getCount CONSTANT) //!< number of directories in list
    Q_PROPERTY(QDeclarativeListProperty<MediaDir> list READ getListProperty NOTIFY listChanged) //!< list of directories where images are
    Q_PROPERTY(QString thumbnailDirPath READ getThumbnailDirPath WRITE setThumbnailDirPath NOTIFY thumbnailDirPathChanged) //!< absolute path to dir with thumbnail files
    Q_PROPERTY(QString appDataDirPath READ getAppDataDirPath CONSTANT) //!< documents directory

public:
    /*!
     * \brief Constructor.
     * \param parent parent object
     */
    explicit MediaRoots(QObject *parent = 0);

    /*!
     * \brief Returns number of directories.
     * \return number of directories
     */
    int getCount() const {return this->m_list.count();}

    /*!
     * \brief Returns directory list.
     * \return list with pointers to directories
     */
    QList<MediaDir*> getList() {return this->m_list;}

    /*!
     * \brief Returns directory list.
     * \return list property with directories
     */
    QDeclarativeListProperty<MediaDir> getListProperty() {return DeclarativeList<MediaDir>::generateProperty(this, &(this->m_list), false, true);}

    /*!
     * \brief Returns absolute path to dir with thumbnail files.
     * \return absolute path to dir with thumbnail files
     */
    QString getThumbnailDirPath() const {return this->thumbnailsDb.getDirPath();}

    /*!
     * \brief Returns absolute path to documents directory.
     * \return absolute path to documents directory of current user
     */
    QString getAppDataDirPath() const;

public slots:
    /*!
     * \brief Sets dir for thumbnail files.
     * \param dirPath absolute path to dir
     */
    void setThumbnailDirPath(const QString dirPath);

signals:
    /*!
     * Emits when thumbnailDirPath ptoperty changes.
     */
    void thumbnailDirPathChanged();

    /*!
     * Emits when list of roots changes.
     */
    void listChanged();

private:
    QList<MediaDir*> m_list; //!< directory list
    MediaThumbnailDb thumbnailsDb; //!< thumbnail generator
};

#endif // _MediaRoots_h_
