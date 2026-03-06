#include "slideshow.h"

#include <QDir>
#include <QFileInfo>

Slideshow::Slideshow(QObject *parent)
    : QObject{parent}
    , m_timer{new QTimer(this)}
{
    m_timer->setInterval(m_interval);
    connect(m_timer, &QTimer::timeout, this, &Slideshow::next);
    m_timer->start();
}


QUrl Slideshow::currentUrl()
{
    if(m_files.isEmpty()) return QUrl();
    return QUrl::fromLocalFile(m_files.at(m_currentIndex));
}


int Slideshow::interval()
{ return m_interval; }

void Slideshow::setInterval(int interval)
{
    m_interval = interval;
    Q_EMIT intervalChanged();

    m_timer->setInterval(m_interval);
    m_timer->stop();
    m_timer->start();
}


QStringList Slideshow::paths()
{ return m_paths; }

void Slideshow::setPaths(QStringList paths)
{
    m_paths = paths;
    Q_EMIT pathsChanged();

    refreshList();
    if(!m_files.isEmpty()) setCurrentIndex(0);
}


bool Slideshow::running()
{ return m_timer->isActive(); }

void Slideshow::setRunning(bool running)
{
    if(running) {
        m_timer->start();
    } else {
        m_timer->stop();
    }

    Q_EMIT runningChanged();
}


void Slideshow::previous()
{ setCurrentIndex(m_currentIndex - 1); }

void Slideshow::toggle()
{ setRunning(!running()); }

void Slideshow::next()
{ setCurrentIndex(m_currentIndex + 1); }


void Slideshow::setCurrentIndex(int index)
{
    if(index >= m_files.length() - 1) index = 0;
    if(index < 0) index = m_files.length() - 1;

    m_currentIndex = index;
    Q_EMIT currentUrlChanged();
    m_timer->stop();
    m_timer->start();
}


void Slideshow::refreshList()
{
    m_files.clear();
    for(QString path : m_paths) {
        QDir dir(path);
        QFileInfoList entries = dir.entryInfoList({"*.png", "*.jpg", "*.bmp", "*.jpeg", "*.webp"},
                                                  QDir::Files | QDir::Readable | QDir::NoDotAndDotDot,
                                                  QDir::Name | QDir::IgnoreCase);

        for(QFileInfo entry : entries) {
            m_files.append(entry.absoluteFilePath());
        }
    }
}
