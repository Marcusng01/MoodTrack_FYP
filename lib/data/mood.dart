class Mood {
  final String validation;
  final String solution;
  final String reflection;

  Mood({
    required this.validation,
    required this.solution,
    required this.reflection,
  });
}

Mood errorMood = Mood(
  validation: 'Error',
  solution: 'Mood does not exist in moodDataCollection',
  reflection:
      'Please ensure mood is passed correctly via moodDataCollection[mood]',
);

Map<String, Mood> moodDataCollection = {
  "admiration": Mood(
    validation: 'Admiration is a positive emotion. Keep going!',
    solution:
        'Keep going with your positive thoughts. They will lead you to success!',
    reflection:
        'Why are you admiring this? What qualities in others inspire you?',
  ),
  "amusement": Mood(
    validation: 'Amusement is great. Enjoy the fun times!',
    solution:
        'Try to find joy in the simple things. That\'s where real amusement comes from.',
    reflection:
        'Remember the things that made you laugh. What made them funny?',
  ),
  "anger": Mood(
    validation: 'It is normal to feel angry after a frustrating experience...',
    solution:
        'Take some time off. Maybe just a few minutes to clear your mind.',
    reflection:
        'Your anger was warranted, but what exactly was it that made you mad? Is there a way to avoid it in the future?',
  ),
  'annoyance': Mood(
    validation:
        'Annoyance is a negative emotion. Try to understand why you feel annoyed and try to change your perspective.',
    solution: 'Find the root cause of your annoyance and address it directly.',
    reflection:
        'What is causing your annoyance? Reflect on the reasons behind your feelings.',
  ),
  'approval': Mood(
    validation: 'Approval is a positive feeling. Good job!',
    solution: 'Celebrate your accomplishments and keep moving forward.',
    reflection: 'Reflect on what you did right. Why does it make you proud?',
  ),
  'caring': Mood(
    validation:
        'Feeling caring towards others is a beautiful emotion. Keep it up!',
    solution:
        'Express your feelings to those around you. Let them know how much they mean to you.',
    reflection:
        'Reflect on the people you care about. What do you appreciate about them?',
  ),
  'confusion': Mood(
    validation:
        'Confusion is a natural part of learning. Don\'t worry, we\'re here to help.',
    solution:
        'Don\'t be afraid to ask for help. Reach out to someone who can guide you.',
    reflection:
        'Reflect on what confused you. What could you have done differently?',
  ),
  'curiosity': Mood(
    validation:
        'Curiosity is a wonderful trait. It drives us to learn and grow.',
    solution:
        'Seek knowledge. There are many resources available online and in libraries.',
    reflection:
        'Reflect on what you want to learn. What interests you about it?',
  ),
  'desire': Mood(
    validation:
        "Desire is a strong emotion that can drives us. What you're feeling now is perfectly reasonable for a human being.",
    solution:
        'Set up goals to achieve your positive desires, set down and understand yourself if you have a negative desires ',
    reflection:
        'If its a positive desire, what can you do to achieve it? If its a negative desire What makes this desire strong?',
  ),
  "disappointment": Mood(
    validation:
        'Disappointment is a common emotion. Try to understand why you\'re disappointed and let go of those feelings.',
    solution:
        'Reframe your disappointment. Consider what you learned from the situation.',
    reflection:
        'Reflect on what you were disappointed about. What could you have done differently?',
  ),
  'disapproval': Mood(
    validation:
        'Disapproval is a negative emotion. Try to understand why you disapprove and work on changing your perspective.',
    solution:
        'Identify the reason for your disapproval and work on improving it.',
    reflection: 'Reflect on what you disapproved of. Why do you disapprove?',
  ),
  'disgust': Mood(
    validation:
        'Disgust is a strong emotion. It helps you react to things that you find unpleasant or harmful.',
    solution: 'Distract yourself. Find activities that bring you joy.',
    reflection: 'Reflect on what disgusted you. Why does it bother you?',
  ),
  'embarrassment': Mood(
    validation:
        'Embarrassment is a common emotion. It\'s okay to feel embarrassed. We all have moments like that.',
    solution:
        'Laugh it off. Everyone makes mistakes and it\'s okay to admit them.',
    reflection:
        'Reflect on what embarrassed you. What could you have done differently?',
  ),
  'excitement': Mood(
    validation:
        'Excitement is a wonderful emotion. It\'s great to feel excited about things!',
    solution: 'Let loose. Have fun and enjoy the excitement.',
    reflection: 'Reflect on what excited you. Why are you excited?',
  ),
  'fear': Mood(
    validation:
        'Fear is a natural emotion. It helps us protect ourselves. Try to identify what scares you and work on it.',
    solution: 'Identify what scares you and find ways to confront it.',
    reflection: 'Reflect on what you fear. Why does it scare you?',
  ),
  'gratitude': Mood(
    validation:
        'Gratitude is a positive emotion. It\'s great to feel grateful. Take a moment to appreciate the good things in your life.',
    solution:
        'Take a moment to appreciate what you have. It could be a small thing, but it\'s worth recognizing.',
    reflection: 'Reflect on what you\'re grateful for. Why are you thankful?',
  ),
  'grief': Mood(
    validation:
        'Grief is a sad emotion. It\'s okay to feel grief. Reach out to someone who can listen.',
    solution:
        'Allow yourself to feel your feelings. Reach out to someone who can listen.',
    reflection: 'Reflect on what caused your grief. How did it affect you?',
  ),
  'joy': Mood(
    validation:
        'Joy is a wonderful emotion. It\'s great to feel joyous. Celebrate the good things in your life.',
    solution: 'Celebrate your joy. Let it fill you up.',
    reflection: 'Reflect on what brought you joy. Why are you happy?',
  ),
  'love': Mood(
    validation:
        'Love is a powerful emotion. It\'s great to feel love. Share your love with others.',
    solution:
        'Express your love to those around you. Let them know how much you care.',
    reflection: 'Reflect on what you love. Why do you love it?',
  ),
  'nervousness': Mood(
    validation:
        'Nervousness is a natural emotion. It\'s okay to feel nervous. Try to relax and focus on the task at hand.',
    solution: 'Breathe deeply. Take slow, deep breaths to calm down.',
    reflection:
        'Reflect on what\'s making you nervous. What could you do to calm down?',
  ),
  'optimism': Mood(
    validation:
        'Optimism is a positive emotion. It\'s great to feel optimistic. Stay positive and keep moving forward.',
    solution:
        'Focus on the positive aspects of your life. Believe in yourself.',
    reflection:
        'Reflect on what you\'re optimistic about. Why do you believe in it?',
  ),
  'pride': Mood(
    validation:
        'Pride is a positive emotion. It\'s great to feel proud. Celebrate your achievements.',
    solution: 'Celebrate your pride. Be proud of your achievements.',
    reflection: 'Reflect on what you\'re proud of. Why are you proud?',
  ),
  'realization': Mood(
    validation:
        'Realization is a powerful emotion. It\'s great to feel realizations. They often come with important insights.',
    solution:
        'Take a moment to acknowledge your realization. It\'s a sign of growth.',
    reflection: 'Reflect on what you realized. What does it mean to you?',
  ),
  'relief': Mood(
    validation:
        'Relief is a wonderful emotion. It\'s great to feel relief. Celebrate the end of something stressful.',
    solution: 'Allow yourself to feel relief. It\'s okay to feel relieved.',
    reflection: 'Reflect on what brought you relief. Why are you relieved?',
  ),
  'remorse': Mood(
    validation:
        'Remorse is a negative emotion. It\'s okay to feel remorse. Try to learn from your mistakes and move forward.',
    solution:
        'Apologize if necessary. Learn from your mistakes and move forward.',
    reflection:
        'Reflect on what you regret. What could you have done differently?',
  ),
  'sadness': Mood(
    validation:
        'Sadness is a natural emotion. It\'s okay to feel sad. Reach out to someone who can listen.',
    solution:
        'Allow yourself to feel your feelings. Reach out to someone who can listen.',
    reflection: 'Reflect on what made you sad. Why do you feel sad?',
  ),
  'surprise': Mood(
    validation:
        'Surprise is a powerful emotion. It\'s great to feel surprised. Try to understand what surprised you.',
    solution:
        'Reflect on the surprises in your life. They can be both good and bad.',
    reflection: 'Reflect on what surprised you. Why were you surprised?',
  )
};
