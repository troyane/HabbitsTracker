import Felgo 3.0
import QtQuick 2.0
import "model"
import "logic"
import "pages"
import "secrets"

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)

    id: app

    licenseKey: Secrets.key
    property int numberAppStarts: 0

    function getSettingsValueOrUseDefault(name, defaultValue) {
        var value = app.settings.getValue(name)
        if (value === undefined) {
            app.settings.setValue(name, defaultValue)
            value = defaultValue
        }
        return value
    }

    function updateNumberAppStartsCount() {
        var tempNumberAppStarts = settings.getValue("numberAppStarts")
        if (tempNumberAppStarts === undefined) {
            // first start
            tempNumberAppStarts = 0
        } else {
            tempNumberAppStarts++
        }
        settings.setValue("numberAppStarts", tempNumberAppStarts)
        numberAppStarts = tempNumberAppStarts
        console.log("It is #" + numberAppStarts + " run of application")
    }

    // Simple data for testing. Located here to be easier to use
    function _debugPrepareData() {
        dataModel.cache.clearAll()
        var jsonData = [
                {
                    "id": "g19yc4bd3vjumu3h2n",
                    "title": "Reading",
                    "description": "Read books, comics, tech literature etc",
                    "icon": "book",
                    "duration": "0.75",
                    "time": "09:00",
                    "days": "Mon,Tue,Wed",
                    "private": false,
                    "notifications": true
                },
                {
                    "id": "iiiuerpitpgjumu3xcg",
                    "title": "Board Games",
                    "description": "Play board games with friends",
                    "icon": "cube",
                    "duration": "2.5",
                    "time": "19:00",
                    "days": "Sun",
                    "private": false,
                    "notifications": true
                },
                {
                    "id": "r9we6s329jjumu41k4",
                    "title": "Calligraphy",
                    "description": "Use brushes to practice in Japanese calligraphy",
                    "icon": "paintbrush",
                    "duration": "1.0",
                    "time": "18:00",
                    "days": "Mon,Wed,Fri",
                    "private": false,
                    "notifications": true
                }
            ];

        dataModel.cache.setValue("habits", jsonData)
        console.log("Already saved!")
    }

    // app initialization
    Component.onCompleted: {
         _debugPrepareData()
        logic.loadHabits()
    }

    // business logic
    Logic { id: logic }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic
        // onLoadHabitsFailed: nativeUtils.displayMessageBox(qsTr("Unable to load habits"), error, 1)
    }

    // view
    Navigation {
        id: navigation
        enabled: true
        NavigationItem {
            id: navHabits
            title: qsTr("Habits list ") + numberAppStarts
            icon: IconType.list

            onSelected: {
                navHabits.navigationStack.currentPage.applySettings()
            }

            NavigationStack {
                id: niHabitsList
                splitView: tablet // use side-by-side view on tablets
                initialPage: HabitsListPage { }
            }
        }

        NavigationItem {
            title: qsTr("Report")
            icon: IconType.barchart

            NavigationStack {
                splitView: tablet // use side-by-side view on tablets
                initialPage: ReportPage { }
            }
        }

        NavigationItem {
            title: qsTr("Profile")
            icon: IconType.user

            NavigationStack {
                initialPage: ProfilePage {
                }
            }
        }
    }
}
