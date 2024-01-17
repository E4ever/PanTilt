#ifndef BASEEXECUTINGMODULE_H
#define BASEEXECUTINGMODULE_H

#include <QObject>
#include "ComPortInterface.h"
#include <QDebug>

/**
 * @brief The BaseExecutingModule class     Base class for executing modules
 */
class BaseExecutingModule : public ComPortInterface
{
    Q_OBJECT
public:
    /**
     * @brief BaseExecutingModule   Constructor
     */
    BaseExecutingModule(ComPortManager *comPortManager = nullptr);

signals:
    /**
     * @brief portIsFree    Signal informing that COM port is free to use now
     */
    void portIsFree();

protected:
    /**
     * @brief preparePacket Function to prepare packet for sending
     * @param packet
     */
    void preparePacket(PacketData &packet);

    ComPortManager *m_comPortManager;   //!< COM-port manager module
};

#endif // BASEEXECUTINGMODULE_H
