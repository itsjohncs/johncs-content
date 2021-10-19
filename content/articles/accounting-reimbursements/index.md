+++
title = "Answering questions with accounting: Reimbursements"
date = "2019-01-07"
+++

I love accounting and to me it's a tool that lets me get answers to my financial questions. For example, I might ask "How much money did I spend eating out versus buying groceries this month?" Even this is a more complicated question to answer than Quicken's developers would like you to believe, but I'll talk about that in some other post.

In this post I'm going to talk about how I found answers to variations of the question "Have I been reimbursed for this therapist visit?" Lemme first take you through the full question…

# The Question

I've seen a therapist once a week for a couple years now. This practice has had a super positive effect on my life, but a less positive effect on my financial health as each visit costs me $200.

My visits haven't been covered by my health insurance for most of that time, but this changed when I was able to join my partner's relatively swanky health insurance from Google late last year 🎉.

With their insurance, I can submit my therapy bills for reimbursement and get most of that money back. Unfortunately the process for getting reimbursed is a little hard to keep track of. Lemme take you through the process for a single month:

1. I see my therapist and pay them $200 via my debit card.
2. Repeat (1) about 3 more times.
3. At the end of the month, my therapist gives me a paper "superbill" that describes the services and prices.
4. I scan and submit that superbill to my insurance company through their web portal.
5. 1 to 4 weeks later my claim is processed and I receive a statement telling me how much I will be reimbursed for.
6. 1 to 4 weeks later my partner receives a bank transfer from my insurance company with the reimbursement.
7. My partner sends me the reimbursement (through bank transfer or Venmo).
8. (Optional) At some point during or after this process, I find that they made a mistake when processing my claim and file a dispute, returning the process to step 5.

After just a few months of this, I found it hard to feel confident that each of my superbills had been properly submitted and that I'd been reimbursed. I hadn't been tracking the process explicitly anywhere, and just submitted superbills when I received them.

I found myself wondering "Did they get a reimbursement recently that they haven't sent me yet?" or "Did I forget to submit any of the superbills?"

# The Preamble to the Answer: Ledger

I use the program [Ledger](https://www.ledger-cli.org) to do my accounting. It's similar to Quicken in that it's a double-entry accounting system, but unlike Quicken it's super manual and gives you lots of control and power at the cost of making you do all the work.

At it's heart, Ledger is a program that reads a Ledger file that has all of your financial data, and tells you things about it (like how much money is in a particular account, how many times you've bought groceries this month, etc). Here's a very simple transaction from my ledger:

```text
2018/01/03 * Trader Joe's
    Expenses:Food:Groceries  $47.70
    Liabilities:Bank of America:Credit Card
```

There's a lot more to say about Ledger, and you should read [its awesome manual](https://www.ledger-cli.org/3.0/doc/ledger3.html) or [plaintextaccounting.org](https://plaintextaccounting.org/) if you want more exposition about it. But this is maybe enough to vaguely understand the rest of this post… Let's hope so.

# The Answer

I now track the entire reimbursement process in my ledger file. The first steps are recorded as purchases of a `THERAPY` commodity from my therapist:

```text
2018/01/03 * Dr. Therapist Person
    Reimbursements:Unsubmitted  1 THERAPY @ =$200.00
    Checking
```

This transaction says "take $200 out of Checking, convert it into 1 `THERAPY` which has a fixed cost of $200, and put that `THERAPY` into `Reimbursements:Unsubmitted`." (The account names I use in my actual ledger file are much longer, but I'll spare you for now.)

The reason I use these commodities rather than just transfering the money is that Ledger will remember the date at which I bought the token. So if I want to know which visits I haven't submitted a claim for, Ledger will tell me directly:

```text
$ ledger -f ledger.dat --lots  balance Reimbursements:Unsubmitted
1 THERAPY {=$200.00} [18-Jan-03]
```

If instead of using these `THERAPY` commodities I just transfered $200 into the Unsubmitted account, I'd need to track which specific visits have been submitted some other way.

Over the course of a month, my Unsubmitted account will gather more `THERAPY` until I get to the next step and submit a superbill. At this point, I'll transfer the specific `THERAPY` lots mentionined in the superbill to another account:

```text
2018/02/03 * Insurance Claim Submission
    Reimbursements:Submitted  1 THERAPY {=$200.00} [2018/01/03]
    Reimbursements:Submitted  1 THERAPY {=$200.00} [2018/01/10]
    Reimbursements:Submitted  1 THERAPY {=$200.00} [2018/01/17]
    Reimbursements:Submitted  1 THERAPY {=$200.00} [2018/01/24]
    Reimbursements:Submitted  1 THERAPY {=$200.00} [2018/01/31]
    Reimbursements:Unsubmitted
```

Now I know that I'm waiting for my insurance company to get back to me. Once they've processed my claim, these `THERAPY` lots are transformed back into cash (though not yet cash that I have access to).

```text
2018/02/27 * Insurance Claim Processed
    Reimbursements:Processed  $720.00
    Expenses:Medical  $80.00
        ; Payee: Dr. Therapist Person
    Reimbursements:Submitted  -1 THERAPY {=$200.00} [2018/01/03]
    Reimbursements:Submitted  -1 THERAPY {=$200.00} [2018/01/10]
    Reimbursements:Submitted  -1 THERAPY {=$200.00} [2018/01/17]
    Reimbursements:Submitted  -1 THERAPY {=$200.00} [2018/01/24]
    Reimbursements:Submitted  -1 THERAPY {=$200.00} [2018/01/31]
```

Now I know there's cash on its way to my partner, and soon I'll complete the process:

```text
2018/03/08 * Partner
    Venmo  $720.00
    Reimbursements:Processed
```

I don't know yet what I'll do when I dispute how one of my claims was processed, but I suspect I have the tools to deal with it.

# Results

Anyways, after painstakingly completing this bookkeeping process for all my therapist visits I was able to discover a couple useful things:

* two of my visits that should've been reimbursed were not
* my partner missed one of the reimbursement transfers and needed to send it to me

Best of all, I have some peace of mind that I know the current reimbursement situation for each of my claims ✨.
