import logger from './logger';

/**
 * In-Memory Lock Utility
 * Simple locking mechanism for single-instance servers
 * Note: For multi-instance deployments, consider using database transactions
 */
export class InMemoryLock {
  private static locks = new Map<string, { value: string; expiresAt: number }>();
  private lockKey: string;
  private lockValue: string;
  private ttl: number; // Time to live in seconds

  constructor(lockKey: string, ttl: number = 10) {
    this.lockKey = `lock:${lockKey}`;
    this.lockValue = `${Date.now()}-${Math.random()}`; // Unique lock value
    this.ttl = ttl;
  }

  /**
   * Clean up expired locks
   */
  private static cleanExpiredLocks() {
    const now = Date.now();
    for (const [key, lock] of InMemoryLock.locks.entries()) {
      if (lock.expiresAt < now) {
        InMemoryLock.locks.delete(key);
      }
    }
  }

  /**
   * Acquire Lock
   * Returns true if lock acquired, false otherwise
   */
  async acquire(): Promise<boolean> {
    try {
      InMemoryLock.cleanExpiredLocks();
      
      const now = Date.now();
      const existingLock = InMemoryLock.locks.get(this.lockKey);
      
      // Check if lock exists and is not expired
      if (existingLock && existingLock.expiresAt > now) {
        logger.debug(`Failed to acquire lock: ${this.lockKey}`);
        return false;
      }
      
      // Acquire lock
      InMemoryLock.locks.set(this.lockKey, {
        value: this.lockValue,
        expiresAt: now + this.ttl * 1000,
      });
      
      logger.debug(`Lock acquired: ${this.lockKey}`);
      return true;
    } catch (error) {
      logger.error(`Error acquiring lock ${this.lockKey}:`, error);
      return false;
    }
  }

  /**
   * Release Lock
   * Only releases if the lock value matches
   */
  async release(): Promise<boolean> {
    try {
      const existingLock = InMemoryLock.locks.get(this.lockKey);
      
      if (existingLock && existingLock.value === this.lockValue) {
        InMemoryLock.locks.delete(this.lockKey);
        logger.debug(`Lock released: ${this.lockKey}`);
        return true;
      }
      
      logger.debug(`Lock not released (not owner): ${this.lockKey}`);
      return false;
    } catch (error) {
      logger.error(`Error releasing lock ${this.lockKey}:`, error);
      return false;
    }
  }

  /**
   * Extend Lock TTL
   * Useful for long-running operations
   */
  async extend(additionalTtl: number): Promise<boolean> {
    try {
      const existingLock = InMemoryLock.locks.get(this.lockKey);
      
      if (existingLock && existingLock.value === this.lockValue) {
        existingLock.expiresAt = Date.now() + additionalTtl * 1000;
        return true;
      }
      
      return false;
    } catch (error) {
      logger.error(`Error extending lock ${this.lockKey}:`, error);
      return false;
    }
  }
}

/**
 * Execute function with in-memory lock
 * Automatically acquires and releases lock
 */
export async function withLock<T>(
  lockKey: string,
  fn: () => Promise<T>,
  options: { ttl?: number; retries?: number; retryDelay?: number } = {}
): Promise<T> {
  const { ttl = 10, retries = 3, retryDelay = 100 } = options;
  const lock = new InMemoryLock(lockKey, ttl);

  let attempts = 0;
  let acquired = false;

  // Try to acquire lock with retries
  while (attempts < retries && !acquired) {
    acquired = await lock.acquire();
    if (!acquired) {
      attempts++;
      if (attempts < retries) {
        await new Promise((resolve) => setTimeout(resolve, retryDelay));
      }
    }
  }

  if (!acquired) {
    throw new Error(`Failed to acquire lock after ${retries} attempts: ${lockKey}`);
  }

  try {
    // Execute the function
    const result = await fn();
    return result;
  } finally {
    // Always release the lock
    await lock.release();
  }
}
