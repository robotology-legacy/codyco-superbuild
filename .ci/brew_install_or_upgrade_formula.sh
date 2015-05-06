#!/bin/bash
function brewInstallSingleFormula() {
    brew list "$1" &> /dev/null || brew install "$1"
}

function brewInstallFormulas() {
    for formula in "$@"
    do
        brewInstallSingleFormula "$formula"
    done
}

function brewInstallOrUpgradeSingleFormula() {
    brewInstallSingleFormula "$1"
    brew outdated "$1" || brew upgrade "$1"
}

function brewInstallOrUpgradeFormulas() {
    for formula in "$@"
    do
        brewInstallOrUpgradeSingleFormula "$formula"
    done
}

