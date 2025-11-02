/*
 * SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "futuredays.h"

#include <klocalizedstring.h>

FutureDays::FutureDays(QObject *parent)
    : QAbstractListModel(parent)
    , m_isNightPresent(false)
    , m_hasProbability(false)
    , m_firstDayExist(false)
    , m_daysNumber(0)
    , m_totalRows(1) // only day forecasts without night forecasts
{
}

FutureDays::~FutureDays()
{
}

QHash<int, QByteArray> FutureDays::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[MonthDay] = "monthDay";
    roles[WeekDay] = "weekDay";
    roles[Period] = "period";
    roles[ConditionIcon] = "conditionIcon";
    roles[Condition] = "condition";
    roles[HighTemp] = "highTemp";
    roles[LowTemp] = "lowTemp";
    roles[ConditionProbability] = "conditionProbability";
    return roles;
}

int FutureDays::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_nextDays.count();
}

QVariant FutureDays::data(const QModelIndex &index, int role) const
{
    if (index.row() >= m_nextDays.count()) {
        return {};
    }

    const std::optional<FutureForecast> &forecast = m_nextDays.at(index.row()).daytime();

    if (!forecast.has_value()) {
        return {};
    }

    switch (role) {
        case MonthDay:
            return m_nextDays.at(index.row()).monthDay().has_value() ? *m_nextDays.at(index.row()).monthDay() : QVariant();
        case WeekDay:
            return m_nextDays.at(index.row()).weekDay().has_value() ? *m_nextDays.at(index.row()).weekDay() : QVariant();
        case ConditionIcon:
            return forecast->conditionIcon().has_value() ? *forecast->conditionIcon() : QVariant();
        case Condition:
            return forecast->condition().has_value() ? *forecast->condition() : QVariant();
        case HighTemp:
            return forecast->highTemp().has_value() ? *forecast->highTemp() : QVariant();
        case LowTemp:
            return forecast->lowTemp().has_value() ? *forecast->lowTemp() : QVariant();
        case ConditionProbability:
            return forecast->conditionProbability().has_value() ? *forecast->conditionProbability() : QVariant();
    }

    return {};
}

void FutureDays::addDay(const FutureDayForecast &forecast)
{
    if(m_nextDays.count() == 4) return;

    beginInsertRows(QModelIndex(), m_nextDays.size(), m_nextDays.size());
    m_nextDays.append(forecast);
    endInsertRows();

    m_daysNumber = m_nextDays.count();
}

void FutureDays::addDays(const QList<FutureDayForecast> &forecasts)
{
    beginResetModel();
    for(int i = 0; i < 5; i++) {
        addDay(forecasts[i]);
    }
    endResetModel();
}

QString FutureDays::firstDayIcon() const
{
    const auto &forecast = m_nextDays.at(0).daytime();

    if (forecast.has_value()) {
        return *forecast->conditionIcon();
    }
    return {};
}

bool FutureDays::isNightPresent() const
{
    return m_isNightPresent;
}

bool FutureDays::hasProbability() const
{
    return m_hasProbability;
}

bool FutureDays::firstDayExist() const
{
    return m_firstDayExist;
}

int FutureDays::daysNumber() const
{
    return m_daysNumber;
}

FutureDayForecast::FutureDayForecast()
{
}

FutureDayForecast::~FutureDayForecast()
{
}

std::optional<int> FutureDayForecast::monthDay() const
{
    return m_monthDay;
}

std::optional<QString> FutureDayForecast::weekDay() const
{
    return m_weekDay;
}

std::optional<FutureForecast> FutureDayForecast::daytime() const
{
    return m_daytime;
}

std::optional<FutureForecast> FutureDayForecast::night() const
{
    return m_night;
}

void FutureDayForecast::setMonthDay(int monthDay)
{
    m_monthDay = monthDay;
}

void FutureDayForecast::setWeekDay(const QString &weekDay)
{
    m_weekDay = weekDay;
}

void FutureDayForecast::setDaytime(const FutureForecast &daytime)
{
    m_daytime = daytime;
}

void FutureDayForecast::setNight(const FutureForecast &night)
{
    m_night = night;
}

FutureForecast::FutureForecast()
{
}

FutureForecast::~FutureForecast()
{
}

std::optional<QString> FutureForecast::conditionIcon() const
{
    return m_conditionIcon;
}

std::optional<QString> FutureForecast::condition() const
{
    return m_condition;
}

std::optional<qreal> FutureForecast::highTemp() const
{
    return m_highTemp;
}

std::optional<qreal> FutureForecast::lowTemp() const
{
    return m_lowTemp;
}

std::optional<qreal> FutureForecast::conditionProbability() const
{
    return m_conditionProbability;
}

void FutureForecast::setConditionIcon(const QString &conditionIcon)
{
    m_conditionIcon = conditionIcon;
}

void FutureForecast::setCondition(const QString &condition)
{
    m_condition = condition;
}

void FutureForecast::setHighTemp(qreal highTemp)
{
    m_highTemp = highTemp;
}

void FutureForecast::setLowTemp(qreal lowTemp)
{
    m_lowTemp = lowTemp;
}

void FutureForecast::setConditionProbability(qreal conditionProbability)
{
    m_conditionProbability = conditionProbability;
}

#include "moc_futuredays.cpp"
