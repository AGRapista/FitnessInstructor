import 'package:flutter/material.dart';
import 'package:project/components/home_components/continue_button.dart';
import 'package:project/utility/date_utilities.dart';
import '../components/appbar.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        const SliverAppBar(
          title: MainAppBar(),
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 50,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              const HeaderContainer(),
              const MonthLabelContainer(),
              const BodyContainer(),
              continue_button(),
            ],
          ),
        ),
      ]),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({Key? key}) : super(key: key);

  final double paddingVal = 10;
  final double marginVal = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingVal),
      margin: EdgeInsets.all(marginVal),
      child: const Center(
        child: Text(
          "Monthly progress",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class MonthLabelContainer extends StatelessWidget {
  const MonthLabelContainer({Key? key}) : super(key: key);

  // Month string
  static final DateTime _now = DateTime.now();
  static final String _monthString = getMonthStringEquivalent(_now.month);
  static final String _yearString = _now.year.toString();
  static final String _label = "$_monthString $_yearString";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          _label,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      padding: EdgeInsets.all(20),
    );
  }
}

class BodyContainer extends StatelessWidget {
  const BodyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProgressCalendar(),
    );
  }
}

class ProgressCalendar extends StatelessWidget {
  const ProgressCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext build) {
    return Table(
      children: CalendarBuilder.constructCalendar(),
    );
  }
}

// -- TODO: DUMMY DATA -- DELETE LATER -- -- DELETE LATER ---- DELETE LATER ---- DELETE LATER -- -- TODO: DUMMY DATA -- DELETE LATER -- -- DELETE LATER ---- DELETE LATER ---- DELETE LATER --
enum DayID { Rest, Complete, Failed }

class CalendarBuilder {
  // * * * * * * * *
  //    FIELDS
  // * * * * * * * *

  // Dates
  static final DateTime _now = DateTime.now();
  static final int _year = _now.year;
  static final int _month = _now.month;
  static final DateTime _firstDayOfMonth = DateTime.utc(_year, _month, 1);

  // Row context
  static const int _maxRows = 6;
  static const int _maxCols = 7;
  static const int _maxCells = _maxRows * _maxCols;

  // Cell context
  static const double _paddingVal = 25;
  static final int _lowerCellsToIgnore = _firstDayOfMonth.weekday;
  static final int _upperCellsToIgnore =
      getDaysInMonth(_firstDayOfMonth) + _firstDayOfMonth.weekday - 1;

  // * * * * * * * *
  //    METHODS
  // * * * * * * * *

  static List<TableRow> constructCalendar() {
    // Row collection
    List<TableRow> rows = [];

    // -- Construct days header --
    TableRow daysHeader = TableRow(
      children: _constructTableHeader(),
    );
    rows.add(daysHeader);

    // -- TODO: DUMMY DATA -- DELETE LATER -- -- DELETE LATER ---- DELETE LATER ---- DELETE LATER -- -- TODO: DUMMY DATA -- DELETE LATER -- -- DELETE LATER ---- DELETE LATER ---- DELETE LATER --
    List<DayID> dummyData = List<DayID>.filled(_maxCells, DayID.Rest);
    dummyData[_firstDayOfMonth.day + 2] = DayID.Complete;
    dummyData[_firstDayOfMonth.day + 3] = DayID.Failed;

    // -- Construct rows and cells --
    int cellPtr = 0; // used for counting cells

    for (int i = 0; i < _maxRows; i++) {
      TableRow currentRow;
      List<Container> cells = [];

      // -- Construct cells --
      for (int i = 0; i < _maxCols; i++) {
        Container cell;

        if (cellPtr < _lowerCellsToIgnore || cellPtr > _upperCellsToIgnore) {
          // Construct empty cell
          cell = Container();
        } else {
          // Construct non-empty cells
          // if (cellCount == DateTime.now().day + 1) {
          //   cell = _constructFailedCell();
          // } else {
          //   cell = _constructRestDayCell();
          // }

          cell = _constructTBACell(); // TODO: Placeholder
          if (cellPtr <= _now.day) {
            switch (dummyData[cellPtr]) {
              case DayID.Complete:
                cell = _constructCompletedCell();
                break;
              case DayID.Failed:
                cell = _constructFailedCell();
                break;
              case DayID.Rest:
                cell = _constructRestDayCell();
                break;
            }

            if (dummyData[cellPtr] == 0) {
              cell = _constructRestDayCell();
            } else if (dummyData[cellPtr] == 1) {}
          } else if (cellPtr == _now.day + 1) {
            cell = _constructTodayCell();
          }
        }

        cells.add(cell);
        cellPtr++;
      }

      currentRow = TableRow(children: cells);
      rows.add(currentRow);
    }

    return rows;
  }

  static List<Widget> _constructTableHeader() {
    const List<String> daysList = ["S", "M", "T", "W", "TH", "F", "S"];
    List<Widget> containersList = [];

    for (String day in daysList) {
      containersList.add(
        Container(
          height: 32,
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        ),
      );
    }

    return containersList;
  }

  static Container _constructRestDayCell() {
    return Container(
      padding: const EdgeInsets.all(_paddingVal),
      color: Colors.lightGreen.shade400,
      margin: const EdgeInsets.all(2),
    );
  }

  static Container _constructCompletedCell() {
    return Container(
      padding: const EdgeInsets.all(_paddingVal),
      margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.green,
        image: DecorationImage(
          image: AssetImage('assets/img/checkmark.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  static Container _constructFailedCell() {
    return Container(
      padding: const EdgeInsets.all(_paddingVal),
      margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.red,
        image: DecorationImage(
          image: AssetImage('assets/img/crossmark.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  static Container _constructTodayCell() {
    return Container(
      padding: const EdgeInsets.all(_paddingVal),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: Colors.green,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  static Container _constructTBACell() {
    return Container(
      padding: const EdgeInsets.all(_paddingVal),
      margin: const EdgeInsets.all(2),
      color: Colors.grey,
    );
  }
}
