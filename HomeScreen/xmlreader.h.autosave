#ifndef XMLREADER_H
#define XMLREADER_H

#include <QObject>
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"

class xmlReader : public QObject
{
    Q_OBJECT
public:
    explicit xmlReader(QObject *parent = nullptr);
    xmlReader(QString filePath, ApplicationsModel &model);
    Q_INVOKABLE void save(int index, QString title, QString icon, QString url, int oldIndex);

private:
    QDomDocument m_xmlDoc; //The QDomDocument class represents an XML document.
    bool ReadXmlFile(QString filePath);
    void PaserXml(ApplicationsModel &model);
    QString m_file;

};

#endif // XMLREADER_H
