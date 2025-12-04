import 'package:flutter/material.dart';
import '../models/game_data.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late GameState gameState;
  late List<GameTask> tasks;
  int currentTaskIndex = 0;
  bool isGameOver = false;
  String gameOverMessage = "";

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      gameState = GameState();
      tasks = GameState.getTasks()..shuffle();
      currentTaskIndex = 0;
      isGameOver = false;
    });
  }

  void handleDecision(bool approved) {
    if (isGameOver) return;

    setState(() {
      if (approved) {
        final task = tasks[currentTaskIndex];
        gameState.budget += task.budgetImpact;
        gameState.satisfaction += task.satisfactionImpact;
        gameState.efficiency += task.efficiencyImpact;
      } else {
        // Slight penalty for rejection sometimes, or just status quo
        // For simplicity, let's say rejecting saves money but might hurt morale slightly if it was a good thing
        // Or we just do nothing. Let's do nothing for rejection for now, or maybe a small efficiency drop if it was needed.
        // Let's keep it simple: Rejection maintains status quo but days pass.
      }

      // Clamp values
      gameState.satisfaction = gameState.satisfaction.clamp(0, 100);
      gameState.efficiency = gameState.efficiency.clamp(0, 100);
      
      gameState.day++;
      
      checkGameOver();

      if (!isGameOver) {
        currentTaskIndex++;
        if (currentTaskIndex >= tasks.length) {
          // Loop tasks or end game
          tasks.shuffle();
          currentTaskIndex = 0;
        }
      }
    });
  }

  void checkGameOver() {
    if (gameState.budget <= 0) {
      isGameOver = true;
      gameOverMessage = "نفذت الميزانية! تم إقالتك.";
    } else if (gameState.satisfaction <= 10) {
      isGameOver = true;
      gameOverMessage = "الموظفون قاموا بإضراب! تم إقالتك.";
    } else if (gameState.efficiency <= 10) {
      isGameOver = true;
      gameOverMessage = "الشركة توقفت عن العمل بسبب الفوضى! تم إقالتك.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("اليوم العملي"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "اليوم: ${gameState.day}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.attach_money, "الميزانية", "${gameState.budget}\$", Colors.green),
                _buildStatItem(Icons.sentiment_satisfied_alt, "الرضا", "${gameState.satisfaction}%", Colors.orange),
                _buildStatItem(Icons.flash_on, "الكفاءة", "${gameState.efficiency}%", Colors.blue),
              ],
            ),
          ),
          
          Expanded(
            child: Center(
              child: isGameOver
                  ? _buildGameOverCard()
                  : _buildTaskCard(tasks[currentTaskIndex]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildTaskCard(GameTask task) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment, size: 48, color: Colors.blue[800]),
          ),
          const SizedBox(height: 24),
          Text(
            task.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            task.description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => handleDecision(false),
                  icon: const Icon(Icons.close),
                  label: const Text("رفض"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => handleDecision(true),
                  icon: const Icon(Icons.check),
                  label: const Text("موافقة"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "التكلفة: ${task.budgetImpact.abs()}\$ | التأثير: ${task.satisfactionImpact > 0 ? '+' : ''}${task.satisfactionImpact} رضا",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 24),
          const Text(
            "انتهت اللعبة",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 16),
          Text(
            gameOverMessage,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: startNewGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text("محاولة جديدة"),
          ),
        ],
      ),
    );
  }
}
