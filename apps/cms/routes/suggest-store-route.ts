import { Express } from 'express';

export function registerSuggestStoreRoute(app: Express, context: any) {
  app.post('/api/suggest-store', async (req, res) => {
    try {
      const data = req.body;

      const result = await context.query.SuggestedStore.createOne({
        data: {
          name: data.name,
          location: data.location,
          description: data.description,
          website: data.website,
          businessHour: data.businessHour,
        },
      });

      res.status(200).json({ success: true, id: result.id });
    } catch (err) {
      console.error('Suggest Store Error:', err);
      res.status(500).json({ success: false, error: 'Internal error' });
    }
  });
}
