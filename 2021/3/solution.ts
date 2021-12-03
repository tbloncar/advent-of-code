class BitTracker {
  zeroCount: number;
  oneCount: number;

  constructor() {
    this.zeroCount = 0;
    this.oneCount = 0;
  }

  track(bit: number): void {
    switch(bit) {
      case 0:
        this.zeroCount += 1;
        break;
      case 1:
        this.oneCount += 1;
        break;
    }
  }

  // Return the most common bit, choosing 1 if we have equality
  mostCommon(): number {
    if (this.zeroCount > this.oneCount) {
      return 0;
    } else {
      return 1;
    }
  }
}

function parseDiagnostics(report: string): string[] {
  return report.split("\n");
}

function flipBits(bits: string): string {
  return bits.split('').reduce((acc: string, bit: string) => {
    return acc + (bit === '0' ? '1' : '0');
  }, '');
}

function computeRates(diagnostics: string[]): number[] {
  // Initialize bit tracker
  let bitTrackers: BitTracker[] = [];
  for(let i = 0; i < diagnostics[0].length; i++) {
    bitTrackers.push(new BitTracker());
  }

  // Update the bit tracker at each position for each line in the diagnostic report
  diagnostics.forEach((diagnostic: string) => {
    bitTrackers.forEach((_: any, i: number) => {
      bitTrackers[i].track(parseInt(diagnostic[i], 10));
    })
  });

  let gammaBinary = '';
  bitTrackers.forEach((bitTracker: BitTracker) => {
    gammaBinary += bitTracker.mostCommon().toString();
  });

  const epsilonBinary = flipBits(gammaBinary);

  return [parseInt(gammaBinary, 2), parseInt(epsilonBinary, 2)];
}

function groupByBit(diagnostics: string[], bitIndex: number): Array<Array<string>> {
  const buckets: Array<Array<string>> = [[],[]];

  diagnostics.forEach((diagnostic: string) => {
    buckets[parseInt(diagnostic[bitIndex], 10)].push(diagnostic);
  });

  return buckets;
}

function computeRatings(diagnostics: string[]): number[] {
  let [oxygenGeneratorRating, co2ScrubberRating] = [0, 0];
  let [mostCommonBucket, leastCommonBucket] = [diagnostics, diagnostics];

  for(let i = 0; i < diagnostics[0].length; i++) {
    const [zeroBucket, oneBucket] = groupByBit(mostCommonBucket, i);

    if (zeroBucket.length > oneBucket.length) {
      mostCommonBucket = zeroBucket;
    } else {
      mostCommonBucket = oneBucket;
    }

    if (mostCommonBucket.length === 1) {
      oxygenGeneratorRating = parseInt(mostCommonBucket[0], 2);
      break;
    }
  }

  for(let i = 0; i < diagnostics[0].length; i++) {
    const [zeroBucket, oneBucket] = groupByBit(leastCommonBucket, i);

    if (zeroBucket.length > oneBucket.length) {
      leastCommonBucket = oneBucket;
    } else {
      leastCommonBucket = zeroBucket;
    }

    if (leastCommonBucket.length === 1) {
      co2ScrubberRating = parseInt(leastCommonBucket[0], 2);
      break;
    }
  }

  return [oxygenGeneratorRating, co2ScrubberRating];
}

function solution(input: string) {
  const diagnostics = parseDiagnostics(input.trim());
  console.log(`Diagnostics: ${diagnostics.length}`);

  const [gamma, epsilon] = computeRates(diagnostics);
  console.log(`Gamma: ${gamma}`)
  console.log(`Epsilon: ${epsilon}`)

  console.log(`Part 1 answer: ${gamma * epsilon}`)

  const [oxygenGeneratorRating, co2ScrubberRating] = computeRatings(diagnostics);
  console.log(`Oxygen: ${oxygenGeneratorRating}`)
  console.log(`CO2: ${co2ScrubberRating}`)

  console.log(`Part 2 answer: ${oxygenGeneratorRating * co2ScrubberRating}`)
}

const fs = require('fs');

fs.readFile('./input.txt', 'utf8' , (err: Error, data: string) => {
  if (err) {
    console.error(err);
    return;
  }
  solution(data);
})