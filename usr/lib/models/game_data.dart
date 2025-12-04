class GameTask {
  final String title;
  final String description;
  final int budgetImpact;
  final int satisfactionImpact;
  final int efficiencyImpact;

  GameTask({
    required this.title,
    required this.description,
    required this.budgetImpact,
    required this.satisfactionImpact,
    required this.efficiencyImpact,
  });
}

class GameState {
  int budget;
  int satisfaction;
  int efficiency;
  int day;

  GameState({
    this.budget = 10000,
    this.satisfaction = 50,
    this.efficiency = 50,
    this.day = 1,
  });

  // Sample tasks generator
  static List<GameTask> getTasks() {
    return [
      GameTask(
        title: "طلب شراء طابعة جديدة",
        description: "الموظفون يشتكون من بطء الطابعة القديمة. هل توافق على شراء طابعة حديثة؟",
        budgetImpact: -500,
        satisfactionImpact: 10,
        efficiencyImpact: 15,
      ),
      GameTask(
        title: "حفلة عيد ميلاد",
        description: "أحد الموظفين يقترح إقامة حفلة صغيرة بمناسبة عيد ميلاده أثناء العمل.",
        budgetImpact: -100,
        satisfactionImpact: 15,
        efficiencyImpact: -10,
      ),
      GameTask(
        title: "تقليص ساعات العمل",
        description: "اقتراح بتقليل ساعة عمل يومياً لزيادة الراحة.",
        budgetImpact: 0,
        satisfactionImpact: 20,
        efficiencyImpact: -20,
      ),
      GameTask(
        title: "دورة تدريبية مكثفة",
        description: "إرسال الموظفين لدورة تدريبية في عطلة نهاية الأسبوع.",
        budgetImpact: -1000,
        satisfactionImpact: -10,
        efficiencyImpact: 30,
      ),
      GameTask(
        title: "صيانة التكييف",
        description: "نظام التكييف يحتاج صيانة دورية.",
        budgetImpact: -300,
        satisfactionImpact: 5,
        efficiencyImpact: 5,
      ),
      GameTask(
        title: "توظيف مساعد جديد",
        description: "ضغط العمل مرتفع، هل نوظف مساعداً إدارياً جديداً؟",
        budgetImpact: -2000,
        satisfactionImpact: 10,
        efficiencyImpact: 25,
      ),
       GameTask(
        title: "رفض إجازة طارئة",
        description: "موظف يطلب إجازة طارئة في وقت تسليم مشروع مهم.",
        budgetImpact: 0,
        satisfactionImpact: -20,
        efficiencyImpact: 10,
      ),
    ];
  }
}
