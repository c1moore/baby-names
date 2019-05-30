import { Component, OnInit, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-faq',
  templateUrl: './faq.component.html',
  styleUrls: ['./faq.component.sass']
})
export class FaqComponent implements OnInit {
  @Output() close: EventEmitter<void> = new EventEmitter();

  public faqs: { question: string, answer: string }[] = [
    {
      question: 'I submitted a few names, but I thought of another.  Can I add another guess?',
      answer:   'Yes, you can submit more guesses at any time.  Your new guesses will be added to the list of names you already guessed.',
    },
    {
      question: `I can't remember if I submitted a name.  Is there any way I cansee what I've already guessed?`,
      answer:   `Not at this time, but you can always submit the same guess multiple times.  It won't count against you at all.`,
    },
    {
      question: `Does anybody know the sex of the baby?`,
      answer:   `Just Stephanie, Calvin, and our doctor.`,
    },
    {
      question: `I saw more (blue|pink) than (pink|blue), does this mean you're having a (boy|girl)?`,
      answer:   `You're imagining things.`
    },
    {
      question: `(Pink|Blue) was the first color in X.  Does that mean you're having a (girl|boy)?`,
      answer:   `No, there are absolutely no hints on this website or on the backend as to sex or name.  If there was a decision as to what color to put first, it was randomized using a cryptographically secure random number generator.  No Freudian slips.`,
    },
  ];

  ngOnInit() {
  }

  onClose(): void {
    this.close.emit();
  }
}
