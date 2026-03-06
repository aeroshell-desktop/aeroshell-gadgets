#ifndef SLIDESHOW_H
#define SLIDESHOW_H

#include <QObject>
#include <QTimer>
#include <QUrl>
#include <QStringList>
#include <qqmlintegration.h>

class Slideshow : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QUrl currentUrl READ currentUrl NOTIFY currentUrlChanged)

    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
    Q_PROPERTY(QStringList paths READ paths WRITE setPaths NOTIFY pathsChanged)

    Q_PROPERTY(bool running READ running WRITE setRunning NOTIFY runningChanged)

public:
    explicit Slideshow(QObject *parent = nullptr);

    QUrl currentUrl();

    int interval();
    void setInterval(int interval);

    QStringList paths();
    void setPaths(QStringList paths);

    bool running();
    void setRunning(bool running);

    Q_INVOKABLE void previous();
    Q_INVOKABLE void toggle();
    Q_INVOKABLE void next();

Q_SIGNALS:
    void currentUrlChanged();

    void intervalChanged();
    void pathsChanged();

    void runningChanged();

private:
    void setCurrentIndex(int index);

    void refreshList();

    QStringList m_paths{};
    int m_currentIndex{};
    int m_interval{3000};
    QTimer *m_timer{nullptr};

    QStringList m_files{};
};

#endif
