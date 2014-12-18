#/bin/bash

if [ ! -e $GERRIT_HOME/gerrit/gerrit-initialized ]; then
    # First run of the container.
    if [ -e $GERRIT_HOME/gerrit.config ] ; then
        # The user bind mounted their own config file. Copy it in.
        mkdir -p $GERRIT_HOME/gerrit/etc
        cp $GERRIT_HOME/gerrit.config $GERRIT_HOME/gerrit/etc/
    fi
    chown -R ${GERRIT_USER}:${GERRIT_USER} $GERRIT_HOME
    # Run init and reindex (because init didn't?!)
    sudo -u ${GERRIT_USER} java -jar $GERRIT_WAR init --batch -d $GERRIT_HOME/gerrit
    sudo -u ${GERRIT_USER} java -jar $GERRIT_WAR reindex -d $GERRIT_HOME/gerrit
    # Mark the init as done.
    sudo -u ${GERRIT_USER} touch $GERRIT_HOME/gerrit/gerrit-initialized
fi

sudo -u ${GERRIT_USER} $GERRIT_HOME/gerrit/bin/gerrit.sh start

