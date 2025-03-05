-- Migration to create or update the handle_payment_success function

-- Drop the function if it exists to ensure a clean slate
DROP FUNCTION IF EXISTS handle_payment_success(UUID, DECIMAL, INTEGER, TEXT);

-- Create the handle_payment_success function
CREATE OR REPLACE FUNCTION handle_payment_success(
  p_user_id UUID,
  p_amount DECIMAL,
  p_tokens INTEGER,
  p_stripe_checkout_id TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Check if the user exists
  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = p_user_id) THEN
    RAISE EXCEPTION 'User with ID % does not exist', p_user_id;
  END IF;

  -- Record the payment transaction
  INSERT INTO payment_transactions (
    user_id,
    amount,
    status,
    stripe_checkout_id,
    transaction_time
  ) VALUES (
    p_user_id,
    p_amount,
    'completed',
    p_stripe_checkout_id,
    NOW()
  );

  -- Update user's wallet
  UPDATE user_wallets
  SET 
    tokens = tokens + p_tokens,
    updated_at = NOW()
  WHERE user_id = p_user_id;

  RETURN true;
EXCEPTION WHEN OTHERS THEN
  -- Log the error details
  RAISE LOG 'Error in handle_payment_success for user ID % (amount: %, tokens: %, checkout_id: %): %', p_user_id, p_amount, p_tokens, p_stripe_checkout_id, SQLERRM;
  -- Re-raise the error to ensure the transaction fails properly
  RAISE;
END;
$$;

-- Add helpful comment
COMMENT ON FUNCTION handle_payment_success IS 'Handles successful payment processing and token allocation';
