#include "xmlreader.h"
#include <QDebug>

xmlReader::xmlReader(QObject *parent) : QObject(parent)
{

}


xmlReader::xmlReader(QString filePath, ApplicationsModel &model)
{
    m_file = filePath;
    ReadXmlFile(filePath);
    PaserXml(model);
}


bool xmlReader::ReadXmlFile(QString filePath)
{
    // Load xml file as raw data
    QFile f(filePath);

    if (!f.open(QIODevice::ReadOnly ))
    {
        // Error while loading file
        return false;
    }
    // Set data into the QDomDocument before processing

    m_xmlDoc.setContent(&f);
    f.close();
    return true;
}

void xmlReader::PaserXml(ApplicationsModel &model)
{
    // Extract the root markup
    QDomElement root=m_xmlDoc.documentElement();

    // Get the first child of the root (Markup COMPONENT is expected)
    QDomElement Component=root.firstChild().toElement();

    // Loop while there is a child
    while(!Component.isNull())
    {
        // Check if the child tag name is COMPONENT
        if (Component.tagName()=="APP")
        {

            // Read and display the component ID
            QString ID=Component.attribute("ID","No ID");

            // Get the first child of the component
            QDomElement Child=Component.firstChild().toElement();

            QString title;
            QString url;
            QString iconPath;

            // Read each child of the component node
            while (!Child.isNull())
            {
                // Read Name and value
                if (Child.tagName()=="TITLE") title = Child.firstChild().toText().data();
                if (Child.tagName()=="URL") url = Child.firstChild().toText().data();
                if (Child.tagName()=="ICON_PATH") iconPath = Child.firstChild().toText().data();

                // Next child
                Child = Child.nextSibling().toElement();
            }

            ApplicationItem item(title,url,iconPath);
            model.addApplication(item);
        }

        // Next component
        Component = Component.nextSibling().toElement();
    }

}

void xmlReader::save(int index, QString title, QString icon, QString url, int oldIndex)
{
    QString titleTmp, iconTmp, urlTmp, titleTmp1, iconTmp1, urlTmp1;
    int i = index;
    QDomDocument document;
    QFile xmlFile(m_file);
    if(!xmlFile.open(QIODevice::ReadOnly)){
        qDebug() << "Failed to open file to read";
    }else{
        if(!document.setContent(&xmlFile)){
            qDebug() << "Failed to load file";
        }
        xmlFile.close();
    }

    QDomElement root = document.firstChildElement();
    QDomElement App = root.firstChildElement();

    //tim vt index moi va luu gia tri
    while (!App.isNull()) {
        if (App.attribute("ID") == QString::number(index)){
            QDomElement child = App.firstChildElement();
            while (!child.isNull()) {
                if(child.tagName() == "TITLE"){
                    titleTmp = child.firstChild().toText().data();
                    child.firstChild().toText().setData(title);
                }
                if(child.tagName() == "URL"){
                    urlTmp = child.firstChild().toText().data();
                    child.firstChild().toText().setData(url);
                }
                if(child.tagName() == "ICON_PATH"){
                    iconTmp = child.firstChild().toText().data();
                    child.firstChild().toText().setData(icon);
                }
                child = child.nextSibling().toElement();
            }
            break;
        }
        App = App.nextSibling().toElement();
    }

    if(index < oldIndex){
        while (i < oldIndex) {
            i++;
            App = App.nextSibling().toElement();
            QDomElement child = App.firstChildElement();

                while (!child.isNull()) {
                    if(child.tagName() == "TITLE"){
                        titleTmp1 = child.firstChild().toText().data();
                        child.firstChild().toText().setData(titleTmp);
                        titleTmp = titleTmp1;
                    }
                    if(child.tagName() == "URL"){
                        urlTmp1 = child.firstChild().toText().data();
                        child.firstChild().toText().setData(urlTmp);
                        urlTmp = urlTmp1;
                    }
                    if(child.tagName() == "ICON_PATH"){
                        iconTmp1 = child.firstChild().toText().data();
                        child.firstChild().toText().setData(iconTmp);
                        iconTmp = iconTmp1;
                    }
                    child = child.nextSibling().toElement();
                }
        }
    }


    if(index > oldIndex){
        while (i > oldIndex) {
            i--;
            App = App.previousSibling().toElement();
            QDomElement child = App.firstChildElement();

            while (!child.isNull()) {
                if(child.tagName() == "TITLE"){
                    titleTmp1 = child.firstChild().toText().data();
                    child.firstChild().toText().setData(titleTmp);
                    titleTmp = titleTmp1;
                }
                if(child.tagName() == "URL"){
                    urlTmp1 = child.firstChild().toText().data();
                    child.firstChild().toText().setData(urlTmp);
                    urlTmp = urlTmp1;
                }
                if(child.tagName() == "ICON_PATH"){
                    iconTmp1 = child.firstChild().toText().data();
                    child.firstChild().toText().setData(iconTmp);
                    iconTmp = iconTmp1;
                }
                child = child.nextSibling().toElement();
            }
        }

    }

    if(!xmlFile.open(QIODevice::WriteOnly)){
        qDebug() << "Failed to open file to write";
    }else{
        xmlFile.write(document.toByteArray(5));
        xmlFile.close();
    }

}
