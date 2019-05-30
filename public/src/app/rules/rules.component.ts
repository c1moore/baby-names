import { Component, OnInit, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-rules',
  templateUrl: './rules.component.html',
  styleUrls: ['./rules.component.sass']
})
export class RulesComponent implements OnInit {
  @Output() close: EventEmitter<void> = new EventEmitter();

  public rules: string[] = [
    'There is no limit on the number of names you can submit.  In fact, we encourage you to enter all the boy and girl names that come to mind.',
    `Nicknames and alternative spellings do not count; you must get the name exactly right.  For example, if the baby's name is Raymond, RayRay does not count.  Similarly, if the name is Rey, Ray will not count.`,
    'The first person to guess the right name will win the grand prize.  Everybody that guesses the name right will get a prize.',
    'Names must be submitted by 1:00pm on July 13 (the day of the baby shower) to be eligible for the prize.',
    'Do not share your guesses with anybody else.',
  ];

  ngOnInit() {
  }

  onClose(): void {
    this.close.emit();
  }
}
