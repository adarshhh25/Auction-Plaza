import mongoose, { Schema, Document, Model } from 'mongoose';

/**
 * Auction Status Enumeration
 */
export enum AuctionStatus {
  PENDING = 'Pending',
  ACTIVE = 'Active',
  ENDED = 'Ended',
  CANCELLED = 'Cancelled',
}

/**
 * Auction Interface
 */
export interface IAuction extends Document {
  title: string;
  description: string;
  images: string[];
  startingPrice: number;
  currentHighestBid: number;
  minimumIncrement: number;
  startTime: Date;
  endTime: Date;
  seller: mongoose.Types.ObjectId;
  status: AuctionStatus;
  winner?: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Auction Schema Definition
 */
const AuctionSchema: Schema<IAuction> = new Schema(
  {
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
      minlength: [5, 'Title must be at least 5 characters'],
      maxlength: [200, 'Title cannot exceed 200 characters'],
    },
    description: {
      type: String,
      required: [true, 'Description is required'],
      trim: true,
      minlength: [10, 'Description must be at least 10 characters'],
      maxlength: [2000, 'Description cannot exceed 2000 characters'],
    },
    images: {
      type: [String],
      validate: {
        validator: function (v: string[]) {
          return v && v.length > 0 && v.length <= 10;
        },
        message: 'Must have between 1 and 10 images',
      },
    },
    startingPrice: {
      type: Number,
      required: [true, 'Starting price is required'],
      min: [0.01, 'Starting price must be greater than 0'],
    },
    currentHighestBid: {
      type: Number,
      default: 0,
    },
    minimumIncrement: {
      type: Number,
      required: [true, 'Minimum increment is required'],
      min: [0.01, 'Minimum increment must be greater than 0'],
    },
    startTime: {
      type: Date,
      required: [true, 'Start time is required'],
    },
    endTime: {
      type: Date,
      required: [true, 'End time is required'],
      validate: {
        validator: function (this: IAuction, value: Date) {
          return value > this.startTime;
        },
        message: 'End time must be after start time',
      },
    },
    seller: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Seller is required'],
    },
    status: {
      type: String,
      enum: Object.values(AuctionStatus),
      default: AuctionStatus.PENDING,
    },
    winner: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  {
    timestamps: true,
    toJSON: {
      transform: function (_doc, ret) {
        delete (ret as any).__v;
        return ret;
      },
    },
  }
);

/**
 * Indexes for optimized queries
 */
AuctionSchema.index({ status: 1 });
AuctionSchema.index({ endTime: 1 });
AuctionSchema.index({ seller: 1 });
AuctionSchema.index({ status: 1, endTime: 1 }); // Compound index for auction job

/**
 * Pre-save validation
 */
AuctionSchema.pre('save', function (next) {
  const auction = this as IAuction;

  // Initialize currentHighestBid to startingPrice if not set
  if (auction.isNew && !auction.currentHighestBid) {
    auction.currentHighestBid = auction.startingPrice;
  }

  next();
});

/**
 * Auction Model
 */
const Auction: Model<IAuction> = mongoose.model<IAuction>('Auction', AuctionSchema);

export default Auction;
